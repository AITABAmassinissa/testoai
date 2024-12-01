import os

namespace='oai1'
ip_adress="10.244.0.2"
nb_pods=10
network="cni0"
user="maitaba@access.grid5000.fr"
master="grenoble"
workers1="nancy"
workers2="rennes"

print("Core is ok")    
#get amf ip adress
amf_ip=os.popen("kubectl get pod -n "+namespace+" $(kubectl get pods --namespace "+namespace+" -l "+"app.kubernetes.io/name=oai-amf"+" -o jsonpath="+"{.items[0].metadata.name}"+") --template '{{.status.podIP}}'").read()
os.system("sudo ifconfig "+network+":"+str(1)+" "+str(ip_adress)+" up")
#update OAI-gnb file for UERANSIM 
with open(r'OAI-gnb.yaml', 'r') as file:
    data = file.read()
    file.close()
data = data.replace("yyy", str(amf_ip))
with open(r'UERANSIM/build/OAI-gnb.yaml', 'w') as file:
    file.write(data)
    file.close()
os.system(f"scp {user}:{master}/massi/testoai/UERANSIM/build/OAI-gnb.yaml {user}:{workers1}/massi/testoai/OAI-gnb.yaml")
os.system(f"scp {user}:{master}/massi/testoai/UERANSIM/build/OAI-gnb.yaml {user}:{workers2}/massi/testoai/OAI-gnb.yaml")
data = data.replace("xxx", str(ip_adress))
with open(r'UERANSIM/build/OAI-gnb.yaml', 'w') as file:
    file.write(data)
    file.close()
#update OAI-ue file for UERANSIM 
with open(r'OAI-ue.yaml', 'r') as file:
    data = file.read()
    file.close()
data = data.replace("xxx", str(ip_adress))
data = data.replace("yyy", namespace)
with open(r'UERANSIM/build/OAI-ue.yaml', 'w') as file:
    file.write(data)
    file.close()
