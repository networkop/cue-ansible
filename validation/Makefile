
default: ansible

build:
	cd src; go build  -o ../library/cue_validate main.go

ansible: build
	ansible-playbook -i hosts playbook.yml

ansible-fail: build
	ansible-playbook -i hosts --extra-vars '{"bgp": {"router_id": "192.0.2.999"}}' playbook.yml