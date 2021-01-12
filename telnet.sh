#!/bin/bash
telnet 127.0.0.1 9000
GET /api/GetDeviceInfo HTTP/1.1
HOST:127.0.0.1
