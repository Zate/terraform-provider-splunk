# Copyright 2015 Container Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default: build

fmt:
	go fmt ./...
	@terraform fmt

build:
	go build -o terraform-provider-splunk .

test:
	go test ./...

testacc:
	TF_ACC=1 go test ./... -v

docker-test : $(eval SHELL:=/bin/bash) $(eval DC:=`which docker-compose`)
	@[ $(DC) == "/usr/local/bin/docker-compose" ] && cd test_server && docker-compose up -d && cd $(PWD) || echo "no docker-compose"
	TF_ACC=1 SPLUNK_PASSWORD=stuff123 SPLUNK_HOME=so1:/opt/SPLUNK_ETC SPLUNK_USERNAME=admin SPLUNK_URL=localhost:8089 go test ./... -v

init:
	@terraform init

plan:
	@terraform plan

apply:
	@terraform apply -auto-approve