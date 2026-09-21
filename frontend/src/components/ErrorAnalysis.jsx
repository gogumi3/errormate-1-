import { useRef, useState } from 'react';

export default function ErrorAnalysis() {
  const [errorLog, setErrorLog] = useState('');
  const [validation, setValidation] = useState('');
  const [notice, setNotice] = useState('');
  const field = useRef(null);

  function handleAnalyze(event) {
    event.preventDefault();
    if (!errorLog.trim()) {
      setValidation('분석할 에러 로그를 입력해 주세요.');
      setNotice('');
      field.current?.focus();
      return;
    }

    setValidation('');
    // TODO: /api/analyze가 준비되면 이 위치에서 분석 API 함수를 호출합니다.
    setNotice('AI 분석 기능을 준비 중입니다. 입력한 내용은 서버로 전송되지 않습니다.');
  }

  return <form id="analysis-panel" className="panel analysis-panel" role="tabpanel" aria-labelledby="analysis-tab" onSubmit={handleAnalyze}>
    <label htmlFor="error-log">에러 로그 분석</label>
    <p className="muted analysis-description">에러 로그, 콘솔 메시지 또는 스택트레이스를 그대로 붙여넣어 주세요.</p>
    <textarea ref={field} id="error-log" className="analysis-textarea" value={errorLog} onChange={event => { setErrorLog(event.target.value); setValidation(''); setNotice(''); }} placeholder={'예: java.lang.NullPointerException\n    at com.example.service.UserService.findUser(UserService.java:42)'} aria-invalid={!!validation} aria-describedby={validation ? 'analysis-validation' : notice ? 'analysis-notice' : undefined}/>
    {validation && <p id="analysis-validation" role="alert" className="validation">{validation}</p>}
    {notice && <p id="analysis-notice" role="status" className="muted">{notice}</p>}
    <div className="analysis-actions"><button className="primary" type="submit">AI로 분석하기</button></div>
  </form>;
}
