#!/usr/bin/env bats

@test "copy ocaml code into place" {
  run cp -r /opt/mirage-web /tmp
  [ "$status" -eq 0 ]
}

@test "configure mirage" {
  cd /tmp/mirage-web
  run env OPAMROOT=/usr/local/opam NET=socket mirage configure --unix
  [ "$status" -eq 0 ]
}

@test "ensure dependencies are installed" {
  cd /tmp/mirage-web
  run env OPAMROOT=/usr/local/opam make depend
  [ "$status" -eq 0 ]
}

@test "build unikernel" {
  cd /tmp/mirage-web
  run env OPAMROOT=/usr/local/opam make
  [ "$status" -eq 0 ]
}

@test "run unikernel in background" {
  run /tmp/mirage-web/mir-www &
}

@test "test unikernel is listening on port 8080" {
  run curl http://localhost:8080
  [ "$status" -eq 0 ]
  [[ "$output" == *"Hello MirageOS"* ]]
}

@test "stop unikernel process" {
  run pkill mir-www
  [ "$status" -eq 0 ]
}
