const base = (import.meta.env.VITE_API_BASE_URL || '').replace(/\/$/, '');
export class ApiError extends Error {
  constructor(message, description = '', suggestion = '', status = 0) {
    super(message); Object.assign(this, { description, suggestion, status });
  }
}
async function get(path, signal) {
  const timeout = AbortSignal.timeout(15000);
  let response;
  try {
    response = await fetch(`${base}${path}`, { signal: AbortSignal.any([signal, timeout]), headers: { Accept: 'application/json' } });
  } catch (error) {
    if (signal.aborted) throw error;
    throw new ApiError(timeout.aborted ? '응답 시간이 길어지고 있어요.' : '서버에 연결할 수 없어요.', '', '잠시 후 다시 시도해 주세요.');
  }
  const data = await response.json().catch(() => null);
  if (!response.ok) {
    // Only show known client-error messages; do not expose server internals.
    if ((response.status === 400 || response.status === 404) && data?.message) {
      throw new ApiError(data.message, data.description, data.suggestion, response.status);
    }
    throw new ApiError('요청을 처리하지 못했어요.', '', '잠시 후 다시 시도해 주세요.', response.status);
  }
  if (!data) throw new ApiError('응답을 읽지 못했어요.', '', '잠시 후 다시 시도해 주세요.');
  return data;
}
export async function searchErrors(keyword, exact, signal) {
  const path = exact ? `/errors/search?${new URLSearchParams({ name: keyword })}` : `/errors/search/partial?${new URLSearchParams({ keyword })}`;
  const data = await get(path, signal);
  const list = exact ? [data] : data;
  if (!Array.isArray(list) || list.some(item => item?.id == null || typeof item.name !== 'string')) throw new ApiError('검색 결과 형식을 확인할 수 없어요.');
  return list;
}
export async function getError(id, signal) {
  const data = await get(`/errors/${encodeURIComponent(id)}`, signal);
  if (data.id == null || typeof data.name !== 'string') throw new ApiError('상세 정보 형식을 확인할 수 없어요.');
  return data;
}
