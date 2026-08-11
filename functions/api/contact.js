const TURNSTILE_VERIFY_URL = 'https://challenges.cloudflare.com/turnstile/v0/siteverify';
const TURNSTILE_ACTION = 'contact-form';
const ALLOWED_HOSTNAME = 'littlevillage-site.pages.dev';

function jsonResponse(body, status) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'content-type': 'application/json' },
  });
}

function isBlank(value) {
  return typeof value !== 'string' || value.trim() === '';
}

async function verifyTurnstile(token, remoteIp, secret) {
  const params = new URLSearchParams();
  params.append('secret', secret);
  params.append('response', token);
  if (remoteIp) params.append('remoteip', remoteIp);

  const response = await fetch(TURNSTILE_VERIFY_URL, { method: 'POST', body: params });
  const result = await response.json();

  const hostnameOk =
    result.hostname === ALLOWED_HOSTNAME ||
    (typeof result.hostname === 'string' && result.hostname.endsWith(`.${ALLOWED_HOSTNAME}`));

  return result.success === true && result.action === TURNSTILE_ACTION && hostnameOk;
}

export async function onRequestPost(context) {
  const { request, env } = context;

  let body;
  try {
    body = await request.json();
  } catch {
    return jsonResponse({ success: false, error: 'Invalid request body.' }, 400);
  }

  const {
    requestType,
    name,
    childDob,
    countyDistrict,
    phone,
    email,
    message,
    honeypot,
    turnstileToken,
  } = body ?? {};

  // Bots that fill the hidden field get a fake success instead of a signal to adapt.
  if (!isBlank(honeypot)) {
    return jsonResponse({ success: true }, 200);
  }

  if (requestType !== 'general' && requestType !== 'tour') {
    return jsonResponse(
      { success: false, error: 'Please select General Inquiry or Schedule a Tour.' },
      400
    );
  }

  if (isBlank(name)) {
    return jsonResponse({ success: false, error: 'Name is required.' }, 400);
  }

  if (isBlank(message)) {
    return jsonResponse({ success: false, error: 'Message is required.' }, 400);
  }

  if (isBlank(phone) && isBlank(email)) {
    return jsonResponse(
      { success: false, error: 'Please provide a phone number or email address.' },
      400
    );
  }

  if (isBlank(turnstileToken) || turnstileToken.length > 2048) {
    return jsonResponse({ success: false, error: 'Verification failed. Please try again.' }, 400);
  }

  const remoteIp = request.headers.get('CF-Connecting-IP');
  const verified = await verifyTurnstile(turnstileToken, remoteIp, env.TURNSTILE_SECRET_KEY);
  if (!verified) {
    return jsonResponse({ success: false, error: 'Verification failed. Please try again.' }, 400);
  }

  return jsonResponse({ success: true }, 200);
}
