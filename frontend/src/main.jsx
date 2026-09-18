import React, { useEffect, useRef, useState } from 'react';
import { createRoot } from 'react-dom/client';
import { searchErrors, getError } from './api';
import './style.css';

const menus = [['search', '에러 검색'], ['favorites', '즐겨찾기'], ['history', '검색 기록'], ['solved', '해결 기록'], ['login', '로그인']];
function routeFromHash() {
  const raw = location.hash.slice(1) || '/';
  const [path, query = ''] = raw.split('?');
  if (path === '/') return { page: 'search', q: new URLSearchParams(query).get('q') || '', exact: new URLSearchParams(query).get('exact') === '1' };
  if (/^\/errors\/\d+$/.test(path)) return { page: 'detail', id: path.split('/')[2] };
  const page = path.slice(1);
  return { page: menus.some(([key]) => key === page) ? page : 'missing' };
}
function ErrorNotice({ error, retry }) {
  return <section className="notice" role="alert"><h2>{error.message}</h2>{error.description && <p>{error.description}</p>}{error.suggestion && <p>{error.suggestion}</p>}{retry && <button onClick={retry}>다시 시도</button>}</section>;
}
function PendingButton({ children }) { return <button disabled title="준비 중인 기능입니다">{children} · 준비 중</button>; }
function TextList({ title, items }) {
  return <section className="panel"><h2>{title}</h2>{Array.isArray(items) && items.length ? <ul>{items.map((text, i) => <li className="multiline" key={i}>{text}</li>)}</ul> : <p className="muted">아직 등록된 내용이 없습니다.</p>}</section>;
}
function App() {
  const [route, setRoute] = useState(routeFromHash);
  const [input, setInput] = useState(route.q || '');
  const [exact, setExact] = useState(route.exact || false);
  const [validation, setValidation] = useState('');
  const [state, setState] = useState({ loading: false, data: null, error: null });
  const [retry, setRetry] = useState(0);
  const [copyMessage, setCopyMessage] = useState('');
  const field = useRef(null);
  const lastSearch = useRef('#/');
  useEffect(() => {
    const handler = () => setRoute(routeFromHash());
    window.addEventListener('hashchange', handler);
    return () => window.removeEventListener('hashchange', handler);
  }, []);
  useEffect(() => {
    const controller = new AbortController();
    setValidation(''); setCopyMessage('');
    if (route.page === 'search') {
      setInput(route.q); setExact(route.exact);
      lastSearch.current = location.hash || '#/';
    }
    const run = async () => {
      if (route.page !== 'detail' && !(route.page === 'search' && route.q.trim())) {
        setState({ loading: false, data: null, error: null }); return;
      }
      setState({ loading: true, data: null, error: null });
      try {
        const data = route.page === 'detail' ? await getError(route.id, controller.signal) : await searchErrors(route.q.trim(), route.exact, controller.signal);
        if (!controller.signal.aborted) setState({ loading: false, data, error: null });
      } catch (error) {
        if (!controller.signal.aborted) setState({ loading: false, data: null, error });
      }
    };
    run();
    return () => controller.abort();
  }, [route, retry]);
  function submit(event) {
    event.preventDefault();
    const keyword = input.trim();
    if (!keyword) { setValidation('검색어를 입력해 주세요.'); field.current?.focus(); return; }
    setValidation('');
    const next = '#/?' + new URLSearchParams({ q: keyword, exact: exact ? '1' : '0' });
    if (location.hash === next) setRetry(value => value + 1);
    else location.hash = next;
  }
  async function copy(code) {
    try { await navigator.clipboard.writeText(code); setCopyMessage('코드를 복사했어요.'); }
    catch { setCopyMessage('복사하지 못했어요. 코드를 선택해서 직접 복사해 주세요.'); }
  }
  const detail = route.page === 'detail' ? state.data : null;
  return <><header><a className="brand" href="#/">ErrorMate<span>에러를 이해하는 시간</span></a><nav aria-label="주 메뉴">{menus.map(([key, label]) => <a key={key} href={key === 'search' ? '#/' : `#/${key}`} aria-current={route.page === key ? 'page' : undefined}>{label}</a>)}</nav></header>
    <main>
      {route.page === 'search' && <><div className="intro"><p className="eyebrow">개발자를 위한 에러 노트</p><h1>어떤 에러를 만났나요?</h1><p>에러의 의미부터 원인과 해결 방법까지 확인하세요.</p></div>
        <form onSubmit={submit} className="panel" role="search"><label htmlFor="keyword">에러 이름 검색</label><div className="search-row"><input ref={field} id="keyword" value={input} onChange={e => { setInput(e.target.value); setValidation(''); }} placeholder="예: NullPointerException 또는 Null" aria-invalid={!!validation} aria-describedby={validation ? 'validation' : undefined}/><button className="primary" type="submit">검색</button></div><label className="check"><input type="checkbox" checked={exact} onChange={e => setExact(e.target.checked)}/> 정확한 이름으로 검색</label>{validation && <p id="validation" role="alert" className="validation">{validation}</p>}</form>
        {!route.q && <p className="muted">에러 이름이나 이름 일부를 입력해 시작하세요.</p>}
        {!state.loading && !state.error && Array.isArray(state.data) && <section aria-label="검색 결과"><h2>검색 결과 <span className="muted">{state.data.length}개</span></h2>{state.data.length === 0 ? <div className="panel"><h3>검색 결과가 없습니다.</h3><p>철자를 확인하거나 더 짧은 이름으로 검색해 보세요.</p></div> : <div className="results">{state.data.map(item => <article className="panel result" key={item.id}><div><span className="tag">{item.language || '에러'}</span><h3><a href={`#/errors/${item.id}`}>{item.name}</a></h3><p>{item.description || '설명이 아직 등록되지 않았습니다.'}</p><a href={`#/errors/${item.id}`}>상세 보기 →</a></div><PendingButton>즐겨찾기</PendingButton></article>)}</div>}</section>}
      </>}
      {route.page === 'detail' && <><a className="back" href={lastSearch.current}>← 검색으로 돌아가기</a>{detail && <><section className="panel"><span className="tag">{detail.language || '에러'}</span><h1>{detail.name}</h1><p className="muted">{[detail.type, detail.category].filter(Boolean).join(' · ')}</p><p className="multiline">{detail.description || '아직 설명이 없습니다.'}</p><div className="actions"><PendingButton>즐겨찾기</PendingButton><PendingButton>해결 완료</PendingButton></div>{detail.messagePattern && <><h2>에러 메시지 예시</h2><pre><code>{detail.messagePattern}</code></pre></>}</section>
        <div className="columns"><TextList title="왜 발생하나요?" items={detail.causes}/><TextList title="어떻게 해결하나요?" items={detail.solutions}/></div>
        <section className="panel"><h2>코드 예제</h2><p role="status">{copyMessage}</p>{detail.codeExamples?.length ? detail.codeExamples.map((example, index) => <article className="example" key={index}><h3>예제 {index + 1}</h3>{[['badCode', '문제가 있는 코드'], ['goodCode', '수정한 코드']].map(([key, label]) => example[key] && <div key={key}><div className="code-label"><h4>{label}</h4><button onClick={() => copy(example[key])}>복사</button></div><pre><code>{example[key]}</code></pre></div>)}{example.explanation && <p className="multiline">{example.explanation}</p>}</article>) : <p className="muted">아직 등록된 코드 예제가 없습니다.</p>}</section>
        <section className="panel"><h2>비슷한 에러</h2>{detail.similarErrors?.length ? <div className="actions">{detail.similarErrors.map((name, i) => <a className="pill" key={i} href={'#/?' + new URLSearchParams({ q: name, exact: '1' })}>{name} 검색 →</a>)}</div> : <p className="muted">아직 연결된 에러가 없습니다.</p>}</section></>}</>}
      {state.loading && <p role="status" className="panel">정보를 불러오는 중입니다…</p>}
      {state.error && <ErrorNotice error={state.error} retry={() => setRetry(n => n + 1)}/>}
      {['favorites', 'history', 'solved', 'login'].includes(route.page) && <section className="panel placeholder"><span className="tag">준비 중</span><h1>{menus.find(([key]) => key === route.page)[1]}</h1><p>{({ favorites: '자주 확인하는 에러를 모아볼 공간이에요.', history: '이전에 검색한 에러를 다시 찾아볼 공간이에요.', solved: '직접 해결한 에러를 기록할 공간이에요.', login: '내 기록과 즐겨찾기를 사용할 수 있도록 준비하고 있어요.' })[route.page]}</p><p className="muted">아직 사용할 수 없는 기능입니다.</p>{route.page === 'login' && <fieldset disabled><legend>로그인</legend><label>이메일<input type="email" placeholder="이메일"/></label><label>비밀번호<input type="password" placeholder="비밀번호"/></label><PendingButton>로그인</PendingButton></fieldset>}<a href="#/">에러 검색으로 돌아가기 →</a></section>}
      {route.page === 'missing' && <section className="panel"><h1>페이지를 찾을 수 없어요.</h1><a href="#/">검색으로 이동</a></section>}
    </main><footer>ErrorMate · 검색하는 시간을 줄이고, 에러를 이해하는 시간을 늘린다.</footer></>;
}
createRoot(document.getElementById('root')).render(<App/>);
