import { all, put, takeEvery } from 'redux-saga/effects';
import axios from 'axios';

import {
	BADGE_ISSUE_RECIPIENT,
	BADGE_ISSUE_RECIPIENT_SUCCES,
	BADGE_ISSUE_RECIPIENT_FAILED
} from './../actions/badgesActions';

function* badgeIssueRecipient(action) {
  try {
		console.log("getting issuer");
		const issuer = yield axios({
			method: 'get',
			url: 'https://api.badgr.io/v1/issuer/issuers',
			// Auth
			headers: {
				'Content-Type': 'application/json',
				'Authorization': `Token ${localStorage.token_badgr}`
			}
		});
		try {
			console.log('sending badge as reward...');
			const result = yield axios({
				method: 'post',
				url: `https://api.badgr.io/v1/issuer/issuers/${issuer.data[1].slug}/badges/${action.data.badge_class}/assertions`,
				data: {
					issuer: issuer.data[1].slug
				},
				data: action.data,
				// Auth
				headers: {
					'Content-Type': 'application/json',
					'Authorization': `Token ${localStorage.token_badgr}`
				}
			});
			yield put({ type: BADGE_ISSUE_RECIPIENT_SUCCES, data: result.data });
		} catch(e) { console.log(e);}
  } catch (e) {
    yield put({ type: BADGE_ISSUE_RECIPIENT_FAILED, message: e.message });
  }
}

// TO DO: show modal
function* failed() {
	yield alert('Error\nError sending the request.');
}

function* badgesSagas() {
	yield all([
		takeEvery(BADGE_ISSUE_RECIPIENT, badgeIssueRecipient),
		takeEvery(BADGE_ISSUE_RECIPIENT_FAILED, failed)
	]);
}

export default badgesSagas;