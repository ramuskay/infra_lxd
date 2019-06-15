# infra_lxd
Create full lxd infra with ansible


## Exemple de inventory ansible

```console
[rweb]
rweb-1.lief.loc

[db]
db-1.lief.loc mysql_role="master" mysql_id="1"
db-2.lief.loc mysql_role="slave" mysql_id="2"

[cloud]
cloud-1.lief.loc ansible_python_interpreter=/usr/bin/python3
```

python 3 pour les ubuntus
ajout de variable pour mysql

## Lancer un job precis

```console
ansible-playbook playbook.yml --limit dns -t dns
```
