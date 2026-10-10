import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
const source = (await readFile(new URL('../src/api.js', import.meta.url), 'utf8')).replace('import.meta.env.VITE_API_BASE_URL', "''");
const api = await import('data:text/javascript;base64,' + Buffer.from(source).toString('base64'));
const signal = () => new AbortController().signal;
test('partial search encodes Korean and reserved characters', async () => {
 globalThis.fetch = async url => { assert.equal(new URL(url, 'http://test').searchParams.get('keyword'), '널 &?'); return Response.json([{id: 1, name: 'NullPointerException'}]); };
 assert.equal((await api.searchErrors('널 &?', false, signal())).length, 1);
});
test('exact search uses name parameter and wraps one result', async () => {
 globalThis.fetch = async url => { assert.equal(url, '/errors/search?name=Null'); return Response.json({id:1,name:'Null'}); };
 assert.equal((await api.searchErrors('Null', true, signal()))[0].id,1);
});
test('empty search results remain an empty array', async () => {
 globalThis.fetch=async()=>Response.json([]); assert.deepEqual(await api.searchErrors('none',false,signal()),[]);
});
test('404 retains user explanation and suggestion', async () => {
 globalThis.fetch=async()=>Response.json({message:'없어요',description:'등록 안 됨',suggestion:'다시 검색'},{status:404});
 await assert.rejects(api.getError(9,signal()), e=>e.status===404 && e.suggestion==='다시 검색');
});
test('500 HTML becomes safe user message', async () => {
 globalThis.fetch=async()=>new Response('<html>internal detail</html>',{status:500});
 await assert.rejects(api.getError(9,signal()), e=>e.message==='요청을 처리하지 못했어요.');
});
test('malformed successful response is rejected', async () => {
 globalThis.fetch=async()=>Response.json({foo:'bar'});
 await assert.rejects(api.searchErrors('x',false,signal()), e=>e instanceof api.ApiError);
});
test('network failure becomes connection guidance', async () => {
 globalThis.fetch=async()=>{throw new TypeError('fetch failed')};
 await assert.rejects(api.getError(1,signal()),e=>e.message==='서버에 연결할 수 없어요.');
});

test('analysis sends only the original errorLog as JSON', async () => {
 const errorLog = '  java.lang.Exception\n    at example.main(Main.java:1)';
 globalThis.fetch = async (url, options) => {
  assert.equal(url, '/api/analyze');
  assert.equal(options.method, 'POST');
  assert.equal(options.headers['Content-Type'], 'application/json');
  assert.deepEqual(JSON.parse(options.body), {errorLog});
  return Response.json({errorName:'NullPointerException',location:'UserService.java:42',problematicCode:'user.getName()',summary:'요약',cause:'원인',solution:'해결'});
 };
 assert.deepEqual(await api.analyzeError(errorLog,signal()), {errorName:'NullPointerException',location:'UserService.java:42',problematicCode:'user.getName()',summary:'요약',cause:'원인',solution:'해결'});
});
test('analysis accepts empty, missing and null DTO fields', async () => {
 for (const response of [{summary:'전체 응답',cause:'',solution:''}, {summary:null}, {}]) {
  globalThis.fetch = async () => Response.json(response);
  const result = await api.analyzeError('log',signal());
  assert.equal(result.cause,''); assert.equal(result.solution,'');
  assert.equal(result.summary,response.summary || '');
  assert.equal(result.errorName,''); assert.equal(result.location,''); assert.equal(result.problematicCode,'');
 }
});
test('analysis metadata tolerates null, blank, unavailable and non-string values', async () => {
 for (const value of [null, '', '   ', '확인 불가', 42, {}, []]) {
  globalThis.fetch = async () => Response.json({errorName:value,location:value,problematicCode:value});
  const result = await api.analyzeError('log',signal());
  for (const key of ['errorName','location','problematicCode']) assert.equal(result[key],typeof value === 'string' ? value : '');
 }
});
test('blank analysis never sends a request', async () => {
 globalThis.fetch = async () => { assert.fail('should not fetch'); };
 await assert.rejects(api.analyzeError(' \n ',signal()), /입력/);
});
test('analysis server failure is reported safely', async () => {
 globalThis.fetch = async () => new Response('private server details',{status:500});
 await assert.rejects(api.analyzeError('log',signal()), /요청을 처리하지 못했어요/);
});
test('aborted analysis remains cancelled', async () => {
 const controller = new AbortController(); controller.abort();
 globalThis.fetch = async (url,options) => { options.signal.throwIfAborted(); };
 await assert.rejects(api.analyzeError('log',controller.signal), {name:'AbortError'});
});
