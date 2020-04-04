#### install ansible in local with below command

```
pip/pip3  install ansible

```

#### Get the miyazaki ansible vault-password(Already stored in the github secrets) from cloud-sre team and store in your local system in HOME directory(~) a file like below

```
 ~/.vault_pass.txt

```

#### Encrypt your variables using ansible-vault as below - Its already done by cloudsre team

```
ansibile-vault encrypt vars/play/secrets.yml --vault-password-file ~/.vault_pass.txt

```

#### View the encrypted variables using below command

```
ansibile-vault view vars/play/secrets.yml --vault-password-file ~/.vault_pass.txt

```

#### Edit the encrypted variables using below command to update environment variables

```
ansibile-vault edit vars/play/secrets.yml --vault-password-file ~/.vault_pass.txt

```
