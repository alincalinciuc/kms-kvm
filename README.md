Examples of USER DATA script that need to be added to the instances running KMS

```{r, engine='bash', count_lines}
#!/bin/bash
echo export NUBOMEDIASTUNSERVERADDRESS=80.96.122.61 > /opt/envvars
echo export NUBOMEDIASTUNSERVERPORT=3478 >> /opt/envvars
echo export NUBOMEDIATRUNSERVERADDRESS=3478 >> /opt/envvars
echo export NUBOMEDIATURNSERVERPORT=3478 >> /opt/envvars
echo export NUBOMEDIAMONITORINGIP=80.96.122.69 >> /opt/envvars
```
