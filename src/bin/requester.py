import zmq
import random
import uuid

HELLO = b'\x00\x00\x00\x00b'
HEARTBEAT = b'\x01\x00\x00\x00b'
WORK = b'\x02\x00\x00\x00b'
GOODBYE = b'\x03\x00\x00\x00b'


ctx = zmq.Context()
socket = ctx.socket(zmq.DEALER)
socket.identity = uuid.uuid4().hex.encode()[0:8]
# addr = "tcp://localhost:6666"
addr = "ipc:///tmp/sl_delegator.socket"
print("connecting to " + addr)
socket.connect(addr)
print("connected.")

i= 3
jobType = b'gravity' 
subject = WORK
batchID = chr(i).encode() # is just a string so can be whatevs
data = b"harro prease"
msg = [batchID, b"", subject, jobType, data]
print("sending message...", msg)
socket.send_multipart(msg)
print("message sent. recieving...")
r = socket.recv_multipart()
print("message recieved", r)