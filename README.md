# Instruction
A dockerized mysql cluster with mysql proxy support

#Usage
Pleae refer to example_run.sh

#Step
1.  create two manamgent node
    go to you first management node 172.31.13.64
       bash start_node.sh -mgmd 1 2 2 1 172.31.13.64 172.31.1.232 172.31.15.42 172.31.14.144 172.31.2.226
    go to your second management node 172.31.1.232
       bash start_node.sh -mgmd 0 2 2 1 172.31.13.64 172.31.1.232 172.31.15.42 172.31.14.144 172.31.2.226
2.  create data node
    go to you first data node 172.31.15.42 and take management node as your argument
       bash start_node.sh -data 1 172.31.13.64
    go to your second data node 172.31.14.144 and take management node as your argument
       bash start_node.sh -data 0 172.31.13.64
3.  create one sql node
    go to you sql node 172.31.2.226
       bash start_node.sh -sql 0 172.31.13.64
