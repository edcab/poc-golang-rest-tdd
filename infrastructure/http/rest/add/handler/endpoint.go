package handler

import (
	"context"
	"encoding/json"
	"github.com/go-kit/kit/endpoint"
	"net/http"
	"poc-golang-rest-tdd/infrastructure/http/rest/add/model"
)

func MakeAddEndpoint() endpoint.Endpoint {
	return func(ctx context.Context, request interface{}) (interface{}, error) {
		var body model.Request
		req := request.(*http.Request)

		err := json.NewDecoder(req.Body).Decode(&body)
		if err != nil {
			return nil, err
		}

		sum := body.CoordinateX + body.CoordinateY

		response := model.Response{Sum: sum}

		return response, nil
	}
}
