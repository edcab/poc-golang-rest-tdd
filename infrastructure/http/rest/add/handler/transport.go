package handler

import (
	"context"
	"encoding/json"
	"net/http"
)

const ContentType = "Content-Type"
const ValueContentType = "application/json; charset=UTF-8"

func DecodeRequest(_ context.Context, r *http.Request) (interface{}, error) {
	return r, nil
}

func EncodeResponse(c context.Context, w http.ResponseWriter, response interface{}) error {
	w.Header().Set(ContentType, ValueContentType)
	return json.NewEncoder(w).Encode(response)
}
