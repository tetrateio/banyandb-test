import http from 'k6/http';
import { check, sleep, fail } from 'k6';
import { Counter } from 'k6/metrics';

const DURATION_INITIAL = `${__ENV.DURATION_INITIAL || '5m'}`;
const DURATION_TARGET = `${__ENV.DURATION_TARGET || '1h'}`;
const INITIAL_VUS = __ENV.INITIAL_VUS || 1;
const TARGET_VUS = __ENV.TARGET_VUS || 10;

const apiUrl = __ENV.API_URL || 'http://service0.test:9999';

const loginCounter = new Counter('login_requests');
const logoutCounter = new Counter('logout_requests');

export let options = {
  scenarios: {
    login_scenario: {
      executor: 'ramping-vus',
      startVUs: INITIAL_VUS,
      stages: [
        { duration: DURATION_INITIAL, target: INITIAL_VUS },
        { duration: DURATION_TARGET, target: TARGET_VUS },
      ],
      exec: 'login',
    },
    logout_scenario: {
      executor: 'ramping-vus',
      startVUs: INITIAL_VUS,
      stages: [
        { duration: DURATION_INITIAL, target: INITIAL_VUS },
        { duration: DURATION_TARGET, target: TARGET_VUS },
      ],
      exec: 'logout',
    },
  },
};

export function login() {
  let res1 = http.get(`${apiUrl}/test1`, { tags: { api: 'test1' } });
  check(res1, { 'login - status was 200': (r) => r.status === 200 }) || fail('Login request failed');
  loginCounter.add(1);
  sleep(1);
}

export function logout() {
  let res2 = http.get(`${apiUrl}/test2`, { tags: { api: 'test2' } });
  check(res2, { 'logout - status was 200': (r) => r.status === 200 }) || fail('Logout request failed');
  logoutCounter.add(1);
  sleep(1);
}
