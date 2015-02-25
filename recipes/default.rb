script 'joindomain' do
  interpreter 'bash'
  user 'root'
  cwd '/tmp'
  code <<-EOH
  #/bin/sh
  echo "joining domain"
    DomainAdmin=#{node['joindomain']['domainadmin']}
    DomainAdminPW=#{node['joindomain']['domainadminpassword']}
    trHostName=$(hostname | tr [':lower:'] [':upper:'])
    domainPath="#{node['joindomain']['domainpath']}"
    kbrealm="#{node['joindomain']['kbrealm']}"
    #addomaindns=#{node['joindomain']['domainddns']}
    # join to domain
    CMP=$(net ads dn "CN=$trHostName,$domainPath" cn -S #{node['joindomain']['specificserver']} -P -l)
    if [ -z $CMP]; then
      net ads join -U $DomainAdmin%$DomainAdminPW \
        createcomputer=$domainPath \
        createupn=host/$upn@$kbrealm > /tmp/netjoin.log 2>&1

      net ads keytab create -U $DomainAdmin%$DomainAdminPW > /tmp/ktpass.log 2>&1
    #  cp /dev/null /etc/openldap/ldap.conf
      exec > /dev/null 2>&1
    fi
  EOH
end
