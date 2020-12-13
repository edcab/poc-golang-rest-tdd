PROJECT_NAME := "poc-golang-rest-tdd"
SUBDIRS_LIST :=
PKG_LIST := $(shell go list ./... | grep -v /vendor/)
VERSION := $(shell cat version)

# OS / Arch we will build our binaries for
OSARCH := "linux/amd64 linux/386 windows/amd64 windows/386 darwin/amd64 darwin/386"

.SILENT: ; # no need for @
.ONESHELL: ; # recipes execute in same shell
.PHONY: build

dependencies: dep ## Download dependencies
	@go mod download

tidy:  ## Execute tidy comand
	@go mod tidy

clean:
	@rm -rf dist \
           ./lambdas \
           ./releases
	@rm -vf \
	 ./coverage.* \
	  ./cpd.*

build:clean tidy
	@for dir in ${SUBDIRS_LIST}; do \
 		echo 'building…' $$dir; \
 		go build  -i -v -o ./dist/$$dir ./$$dir & done

install: build ## Build the binary file
	@for dir in ${SUBDIRS_LIST}; do \
     		echo 'installing…' $$dir; \
     		go install ./$$dir & done

test: ## execute test
	go test -i ${PKG_LIST} || exit 1
	echo ${PKG_LIST} | \
		xargs -t -n4 go test $(TESTARGS) -timeout=30s -parallel=4

package-release: build
	mkdir -v -p $(CURDIR)/releases
	@for dir in ${SUBDIRS_LIST}; do \
		tar -cvzf ./releases/$$dir_${VERSION}_$$platform.tgz -C ./dist/$$dir ; \
	done

release: package-release ## exevute lint
	ghr $(VERSION) releases/


lambda:clean tidy
	@for dir in ${SUBDIRS_LIST}; do \
		echo 'building lambdas…' $$dir; \
		CGO_ENABLED=0 GOOS=linux go build -mod=readonly -v -o ./$$dir/dist/main ./$$dir ; \
		chmod +x $$dir/dist/main; \
		zip -jrm ./$$dir/dist/$$dir.zip ./$$dir/dist/main; \
	done

security: ## Execute go sec security step
	gosec -tests ./...

misspell :## One way of improving the accuracy of your writing is to spell things right.
	@misspell -locale US  .

lint: ## exevute lint
	@golangci-lint run ./...

fmt: ## formmat the files
	@go fmt ./...

cpd:  ## cpd
	dupl -t 200 -html >cpd.html

coverage: ## Generate global code coverage report
	./scripts/coverage.sh;


race:  ## Run data race detector
	@go test -race -short ${PKG_LIST}

bench:  ## run benchmarks
	go test -bench ${PKG_LIST}

msan:  ## Run memory sanitizer
	@go test -msan -short ${PKG_LIST}

vet: ## Vet examines Go source code and reports suspicious constructs, such as Printf calls whose arguments do not align with the format string
	@echo "go vet ."
	@go vet ${PKG_LIST} ; if [ $$? -eq 1 ]; then \
		echo ""; \
		echo "Vet found suspicious constructs. Please check the reported constructs"; \
		echo "and fix them if necessary before submitting the code for review."; \
		exit 1; \
	fi


dep: ## Get the dependencies
	go get -v -u github.com/mattn/goveralls && \
	go get -v -u github.com/mibk/dupl && \
	go get -v -u github.com/client9/misspell/cmd/misspell && \
	go install github.com/tcnksm/ghr && \
	go get github.com/securego/gosec/cmd/gosec && \
	go mod tidy

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
