# Architecture

## High Level Operation of Blue-Green

![hybrid cloud architecture](https://user-images.githubusercontent.com/898384/49408526-9400c180-f797-11e8-9265-e15a6895ab52.png)

- Main idea is, we are manipulating the Route53 weighted records to redirect traffics to different ECS clusters (backed by Fargate).
- There is an API backed by lambda that manage and controls the state of the blue-green. It is also responsible to update the Route 53 records. 
