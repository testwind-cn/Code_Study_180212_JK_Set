#!/bin/bash
scp ./resetEnvAgent.sh nn2:/home/appadm/resetEnvAgent.sh
scp ./resetEnvAgent.sh dn1:/home/appadm/resetEnvAgent.sh
scp ./resetEnvAgent.sh dn2:/home/appadm/resetEnvAgent.sh
scp ./resetEnvAgent.sh dn3:/home/appadm/resetEnvAgent.sh
scp ./resetEnvAgent.sh dn4:/home/appadm/resetEnvAgent.sh
scp ./resetEnvAgent.sh dn5:/home/appadm/resetEnvAgent.sh
scp ./resetEnvAgent.sh dn6:/home/appadm/resetEnvAgent.sh
scp ./resetEnvAgent.sh dn7:/home/appadm/resetEnvAgent.sh
scp ./resetEnvAgent.sh dn8:/home/appadm/resetEnvAgent.sh

ssh nn1 "sh /home/appadm/resetEnv.sh"
ssh nn2 "sh /home/appadm/resetEnvAgent.sh"
ssh dn1 "sh /home/appadm/resetEnvAgent.sh"
ssh dn2 "sh /home/appadm/resetEnvAgent.sh"
ssh dn3 "sh /home/appadm/resetEnvAgent.sh"
ssh dn4 "sh /home/appadm/resetEnvAgent.sh"
ssh dn5 "sh /home/appadm/resetEnvAgent.sh"
ssh dn6 "sh /home/appadm/resetEnvAgent.sh"
ssh dn7 "sh /home/appadm/resetEnvAgent.sh"
ssh dn8 "sh /home/appadm/resetEnvAgent.sh"

