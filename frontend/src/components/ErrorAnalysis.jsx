import { useEffect, useRef, useState } from 'react';
import { analyzeError } from '../api';

export default function ErrorAnalysis({ onSearchError }) {
  const [errorLog, setErrorLog] = useState('');
  const [validation, setValidation] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState(null);
  const field = useRef(null);
  const request = useRef(null);
  useEffect(() => () => request.current?.abort(), []);

  async function handleAnalyze(event) {
    event.preventDefault();
    if (request.current) return;
    if (!errorLog.trim()) {
      setValidation('분석할 에러 로그를 입력해 주세요.');
      field.current?.focus();
      return;
    }
    const controller = new AbortController();
    request.current = controller;
    setValidation(''); setError(''); setResult(null); setLoading(true);
    try {
      const data = await analyzeError(errorLog, controller.signal);
      if (!controller.signal.aborted) setResult(data);
    } catch (failure) {
      if (!controller.signal.aborted) setError(failure.message || '분석하지 못했어요. 잠시 후 다시 시도해 주세요.');
    } finally {
      if (!controller.signal.aborted) { setLoading(false); request.current = null; }
    }
  }

  const availableText = value => typeof value === 'string' && value.trim() && value.trim() !== '확인 불가' ? value : '';
  const errorName = availableText(result?.errorName).trim();
  const location = availableText(result?.location);
  const problematicCode = availableText(result?.problematicCode);

  return <div id="analysis-panel" role="tabpanel" aria-labelledby="analysis-tab">
    <form className="panel analysis-panel" onSubmit={handleAnalyze} aria-busy={loading}>
      <label htmlFor="error-log">에러 로그 분석</label>
      <p className="muted analysis-description">에러 로그, 콘솔 메시지 또는 스택트레이스를 그대로 붙여넣어 주세요.</p>
      <textarea ref={field} id="error-log" className="analysis-textarea" value={errorLog} disabled={loading} onChange={event => { setErrorLog(event.target.value); setValidation(''); setError(''); setResult(null); }} placeholder={'예: java.lang.NullPointerException\n    at com.example.service.UserService.findUser(UserService.java:42)'} aria-invalid={!!validation} aria-describedby={validation ? 'analysis-validation' : undefined}/>
      {validation && <p id="analysis-validation" role="alert" className="validation">{validation}</p>}
      {error && <p role="alert" className="validation">{error}</p>}
      {loading && <p role="status" className="muted">분석 중...</p>}
      <div className="analysis-actions"><button className="primary" type="submit" disabled={loading}>{loading ? '분석 중...' : 'AI로 분석하기'}</button></div>
    </form>
    {result && <section aria-label="AI 분석 결과" aria-live="polite">
      <section className="panel analysis-detected">
        <h2>감지된 에러</h2>
        <p className={errorName ? 'detected-error-name' : 'muted'}>{errorName || '확인 불가'}</p>
        <dl className="analysis-context">
          <dt>문제 위치</dt><dd className={location ? 'multiline' : 'muted'}>{location || '확인 불가'}</dd>
          <dt>문제 코드</dt><dd>{problematicCode ? <pre><code>{problematicCode}</code></pre> : <span className="muted">확인 불가</span>}</dd>
        </dl>
        {errorName && <div className="analysis-actions"><button className="primary" type="button" onClick={() => onSearchError(errorName)}>이 에러 검색하기</button></div>}
      </section>
      {[["summary", "에러 요약"], ["cause", "원인"], ["solution", "해결 방법"]].map(([key, title]) => <section className="panel" key={key}><h2>{title}</h2><p className={result[key].trim() ? 'multiline' : 'muted'}>{result[key].trim() ? result[key] : '서버에서 반환된 내용이 없습니다.'}</p></section>)}
    </section>}
  </div>;
}
