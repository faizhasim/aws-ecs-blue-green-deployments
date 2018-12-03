# Sample Workflow

### 1. Developer make changes to the application code and make a PR in a separate branch.

  ![image](https://user-images.githubusercontent.com/898384/49407722-7b42dc80-f794-11e8-9f3b-9428053cce36.png)
  ![image](https://user-images.githubusercontent.com/898384/49406529-c824b400-f790-11e8-9206-24115c6693ea.png)

### 2. The PR will go through CI. If CI passed, it can get merged to `master`.

  ![image](https://user-images.githubusercontent.com/898384/49406546-da9eed80-f790-11e8-9c02-49b4f1359357.png)

### 3. Anything committed to `master` will trigger CI & CD.

  ![image](https://user-images.githubusercontent.com/898384/49406662-2a7db480-f791-11e8-9adf-4468ce68c203.png)
  
### 4. Specifically, a few things will happen in the following jobs:
  - `build_app`: Code will get build, validated and push to DockerHub.
  - `deploy_single_ecs_cluster`: "test env" without blue-green setup get updated.
  - `deploy_blue_green_ecs_cluster`: Only the "blue" part of blue-green infra will get updated.
  - `request-flip-dns`: A decision need to be done by human operator whether to flip the DNS and upgrade the "blue" infra to "green infra.".

  ![image](https://user-images.githubusercontent.com/898384/49406680-379aa380-f791-11e8-82c0-b45fbd9377de.png)

### 5. The state of blue-green deployment are tracked in this dynamodb table. Noticed that currently all traffic should be redirected to only one of the load balancers.  

  ![image](https://user-images.githubusercontent.com/898384/49407083-6402ef80-f792-11e8-9bad-83cf965dc1b9.png)
  
### 6. Route53 records will reflect the states from the dynamodb table.

  ![image](https://user-images.githubusercontent.com/898384/49407120-84cb4500-f792-11e8-843d-5ea734eed657.png)
  
### 7. As explained, only one of the infra sets will get updated. (Ignore the naming here, but more importantly this is to show that only the ECS cluster corresponds to the correct load balancer get updated. The one currently serving the internet will not get updated.) 

  ![image](https://user-images.githubusercontent.com/898384/49407162-a9bfb800-f792-11e8-91a7-44110be4fb56.png)

### 8. Notice how the actual domain is still being routed to the previous infra.
  - Non-blue-green will always get updated: [screen 2018-12-04 at 06 41 17](https://user-images.githubusercontent.com/898384/49407326-19ce3e00-f793-11e8-9dbd-ccf8892ac3a0.png)
  - Blue-green still get routed to the previous LB: [screen 2018-12-04 at 06 41 22](https://user-images.githubusercontent.com/898384/49407327-19ce3e00-f793-11e8-9add-8a648058bb80.png)
  - Previous infra: [screen 2018-12-04 at 06 41 25](https://user-images.githubusercontent.com/898384/49407328-19ce3e00-f793-11e8-99f9-1932283bbcfd.png)
  - Updated infra, but not routed yet until approval: [screen 2018-12-04 at 06 41 28](https://user-images.githubusercontent.com/898384/49407329-19ce3e00-f793-11e8-82cd-bc2a0077b7a6.png)

### 9. In order to promote "blue" to "green", manual approval need to be done. This step actually call an API to flip the DNS on the Route53. The API call may happen outside of CD for other operational purposes (like reverting the changes).

  ![image](https://user-images.githubusercontent.com/898384/49407503-cd373280-f793-11e8-8c45-0e4eedb85c26.png)

### 10. If the approval step get approved, then it will make the actual switch:

  ![image](https://user-images.githubusercontent.com/898384/49407528-dc1de500-f793-11e8-8e2e-a06c997918fc.png)

### 11. DynamoDB table that hold the state will be updated and the changes will be reflected at the relevant Route53 record sets.

  ![image](https://user-images.githubusercontent.com/898384/49407599-138c9180-f794-11e8-8838-4e7e77bfa35e.png)
  ![image](https://user-images.githubusercontent.com/898384/49407579-053e7580-f794-11e8-8cc0-53ae9746ce7a.png) 

### 12. Eventually, DNS propagation will happen within 60 sec TTL and traffic will be routed to the newly promoted infra.

  ![screen 2018-12-04 at 06 44 09](https://user-images.githubusercontent.com/898384/49407690-61a19500-f794-11e8-941f-ab6553e3e873.png) 
