package main

import "poc-golang-rest-tdd/infrastructure/http/rest"

func main() {

	api := rest.NewAPI()

	api.Start()

}
