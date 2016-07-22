# Instruction
A dockerized mysql cluster with mysql proxy support

#Usage
You can refer to example_run.sh directly or follow the Cluster Setup bellow

#MySql Cluster Setup
1.  Create two manamgent node
    
    1.1   Go to you first management node 172.31.13.64

    bash start_node.sh -mgmd 1 2 2 1 172.31.13.64 172.31.1.232 172.31.15.42 172.31.14.144 172.31.2.226
       
    1.2   Go to your second management node 172.31.1.232
    
    bash start_node.sh -mgmd 0 2 2 1 172.31.13.64 172.31.1.232 172.31.15.42 172.31.14.144 172.31.2.226
       
2.  Create data node

    2.1   Go to you first data node 172.31.15.42 and take management node as your argument
    
    bash start_node.sh -data 1 172.31.13.64
       
    2.2   Go to your second data node 172.31.14.144 and take one management node as your argument
    
    bash start_node.sh -data 0 172.31.13.64
       
3.  Create one sql node and take one management node as your argument

    3.1   Go to you sql node 172.31.2.226
       
    bash start_node.sh -sql 0 172.31.13.64

#MySql Proxy Setup

1. Create Mysql Proxy Server

   1.1 Go to your proxy server 172.31.3.33 and and take sql nodes as your arguments.
   
      cd proxy-server

      bash run.sh 172.31.2.226
      
    If you have more than one sql node, you should append it in the tail, ex bash run.sh sql_ip1 sql_ip2 sql_ip3

#Reference
  http://jaychung.tw/2015/09/12/mysql-cluster-deployment/
  
  https://github.com/g17/MySQL-Cluster
