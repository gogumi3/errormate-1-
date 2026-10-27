// Optional browser regression: start Vite, install Playwright separately, then run this file.
// All API responses here are fixtures; this does not verify a running backend or Gemini.
import assert from 'node:assert/strict';
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const browser = await chromium.launch({ headless: true, ...(process.env.BROWSER_PATH ? { executablePath: process.env.BROWSER_PATH } : {}) });
const context = await browser.newContext({ permissions: ['clipboard-read', 'clipboard-write'] });
const page = await context.newPage();
page.setDefaultTimeout(8000);
const errors = [];
page.on('pageerror', error => errors.push(error.message));
const info = { id: 1, name: 'NullPointerException', language: 'Java', description: 'null 객체 설명', causes: ['null 참조 원인'], solutions: ['null 검사 해결'], codeExamples: [{ badCode: 'user.name', goodCode: 'user?.name', explanation: '코드 설명' }], similarErrors: ['NumberFormatException'] };
const records = { favorites: false, solved: false };
const calls = [];
let fail = '';
let delayCheck = false;
const base = process.env.TEST_URL || 'http://127.0.0.1:5173';
const visible = text => page.getByText(text, { exact: true }).waitFor();
const go = async hash => { await page.evaluate(hash => { location.hash = hash; }, hash); };
await page.route('**/*', async route => {
  const req = route.request();
  const url = new URL(req.url());
  if (!/^\/(favorites|solved|errors|api)(\/|$)/.test(url.pathname)) return route.continue();
  calls.push({ path: url.pathname + url.search, method: req.method(), body: req.postData() });
  if (fail === `${req.method()} ${url.pathname}`) return route.fulfill({ status: 500, body: 'private details' });
  const json = data => route.fulfill({ json: data });
  const match = url.pathname.match(/^\/(favorites|solved)(?:\/(\d+)(\/check)?)?$/);
  if (match) {
    const [, kind, id, check] = match;
    if (check) {
      const value = id === '1' && records[kind];
      if (delayCheck) await new Promise(resolve => setTimeout(resolve, 250));
      return json(value);
    }
    if (req.method() === 'GET') return json(records[kind] ? [info] : []);
    await new Promise(resolve => setTimeout(resolve, 150));
    records[kind] = req.method() === 'POST';
    return route.fulfill({ status: 204 });
  }
  if (url.pathname === '/errors/search/partial') return json([info]);
  if (url.pathname === '/errors/search') return json(info);
  if (url.pathname.startsWith('/errors/')) return json({ ...info, id: Number(url.pathname.split('/')[2]) });
  if (url.pathname === '/api/analyze') return json({ errorName: info.name, summary: 'AI 요약', cause: 'AI 원인', solution: 'AI 해결', location: 'Main.java:1', problematicCode: 'user.name' });
  return route.fulfill({ status: 404 });
});
try {
  await page.goto(base);
  await page.getByLabel('에러 이름 검색').fill('Null');
  await page.getByRole('button', { name: '검색', exact: true }).click();
  await page.getByRole('link', { name: info.name, exact: true }).click();
  await visible('null 참조 원인'); await visible('null 검사 해결'); await visible('코드 설명');
  await page.getByRole('button', { name: '복사', exact: true }).first().click();
  await visible('코드를 복사했어요.');
  assert.equal(await page.evaluate(() => navigator.clipboard.readText()), 'user.name');
  await page.waitForFunction(() => document.querySelector('.saved-action button:not(:disabled)'));
  for (const [kind, off, on, title] of [['favorites','☆ 즐겨찾기','★ 즐겨찾기됨','즐겨찾기'],['solved','✓ 해결했어요','✓ 해결됨','해결 기록']]) {
    const button = page.getByRole('button', { name: off, exact: true });
    await button.evaluate(el => { el.click(); el.click(); el.click(); });
    assert.equal(await button.isDisabled(), true);
    await page.getByRole('button', { name: on, exact: true }).waitFor();
    assert.equal(calls.filter(c => c.path === `/${kind}/1` && c.method === 'POST').length, 1);
    await go(`#/${kind}`);
    await page.getByRole('heading', { name: title, exact: true }).waitFor();
    await page.getByRole('link', { name: info.name, exact: true }).click();
    await page.getByRole('button', { name: on, exact: true }).click();
    await page.getByRole('button', { name: off, exact: true }).waitFor();
    await go(`#/${kind}`);
    await visible(kind === 'favorites' ? '아직 즐겨찾기한 에러가 없습니다.' : '아직 해결 기록이 없습니다.');
    await go('#/errors/1');
  }
  fail = 'GET /favorites/1/check';
  await go('#/'); await page.getByLabel('에러 이름 검색').waitFor(); await go('#/errors/1');
  await visible('요청을 처리하지 못했어요.');
  assert.equal(await page.getByRole('button', { name: '☆ 즐겨찾기', exact: true }).isDisabled(), true);
  assert.equal(await page.getByRole('button', { name: '✓ 해결했어요', exact: true }).isEnabled(), true);
  fail = ''; await page.getByRole('button', { name: '다시 시도', exact: true }).click();
  fail = 'POST /favorites/1';
  await page.getByRole('button', { name: '☆ 즐겨찾기', exact: true }).click();
  await visible('요청을 처리하지 못했어요.');
  fail = ''; await page.getByRole('button', { name: '다시 시도', exact: true }).click();
  await page.getByRole('button', { name: '☆ 즐겨찾기', exact: true }).click();
  await page.getByRole('button', { name: '★ 즐겨찾기됨', exact: true }).waitFor();
  fail = 'DELETE /favorites/1';
  await page.getByRole('button', { name: '★ 즐겨찾기됨', exact: true }).click();
  await visible('요청을 처리하지 못했어요.');
  fail = ''; await page.getByRole('button', { name: '다시 시도', exact: true }).click();
  await page.getByRole('button', { name: '★ 즐겨찾기됨', exact: true }).waitFor();
  fail = 'GET /solved'; await go('#/solved'); await visible('요청을 처리하지 못했어요.');
  fail = ''; await page.getByRole('button', { name: '다시 시도', exact: true }).click();
  await visible('아직 해결 기록이 없습니다.');
  delayCheck = true; await go('#/errors/1'); await page.locator('.saved-actions').waitFor();
  await go('#/errors/2');
  await page.waitForFunction(() => [...document.querySelectorAll('.saved-action button')].length === 2 && [...document.querySelectorAll('.saved-action button')].every(b => !b.disabled));
  assert.equal(await page.getByRole('button', { name: '☆ 즐겨찾기', exact: true }).getAttribute('aria-pressed'), 'false');
  delayCheck = false;
  await page.getByRole('link', { name: 'NumberFormatException 검색 →' }).click();
  await page.getByRole('link', { name: info.name, exact: true }).waitFor();
  assert(calls.some(c => c.path === '/errors/search?name=NumberFormatException'));
  await page.getByRole('tab', { name: '에러 분석', exact: true }).click();
  await page.getByLabel('에러 로그 분석', { exact: true }).fill('java.lang.NullPointerException');
  await page.getByRole('button', { name: 'AI로 분석하기' }).click();
  await visible('AI 요약'); await visible('AI 원인'); await visible('AI 해결');
  await page.getByRole('button', { name: '이 에러 검색하기' }).click();
  await page.getByRole('link', { name: info.name, exact: true }).waitFor();
  assert(calls.some(c => c.path === '/errors/search/partial?keyword=NullPointerException'));
  for (const kind of ['history','login']) { await go(`#/${kind}`); await visible('아직 사용할 수 없는 기능입니다.'); }
  await page.setViewportSize({ width: 375, height: 812 });
  for (const hash of ['#/favorites','#/solved','#/errors/1']) {
    await go(hash);
    await page.waitForFunction(() => document.querySelector('main h1'));
    assert(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), `mobile overflow: ${hash}`);
  }
  assert(calls.filter(c => /^\/(favorites|solved)/.test(c.path)).every(c => c.body === null && !c.path.includes('user')));
  assert.deepEqual(errors, []);
  console.log('PASS: saved toggles/lists/empty/error/retry/duplicate clicks/navigation, search/detail/copy/AI, placeholders, 375px layout (mock APIs).');
} finally {
  await browser.close();
}
