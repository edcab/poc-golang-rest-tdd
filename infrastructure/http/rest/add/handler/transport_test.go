package handler

import (
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func Test_DecodeRequest(t *testing.T) {

	var router httpHandler
	mux := router.CreateHandler()
	srv := httptest.NewServer(mux)

	defer srv.Close()

	for _, testcase := range []struct {
		method, url, body, want string
	}{
		{"POST", srv.URL + "/v1", `{"coordinate_x":1,"coordinate_y":1}`, `{"sum":2}`},
	} {
		req, _ := http.NewRequest(testcase.method, testcase.url, strings.NewReader(testcase.body))
		resp, _ := http.DefaultClient.Do(req)
		body, _ := ioutil.ReadAll(resp.Body)
		if want, have := testcase.want, strings.TrimSpace(string(body)); want != have {
			t.Errorf("%s %s %s: want %q, have %q", testcase.method, testcase.url, testcase.body, want, have)
		}
	}

}

