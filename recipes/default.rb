domains = data_bag('domains')

domains.each do |domain|
  opts = data_bag_item('domains', domain)

  template '/tmp/joindomain.sh' do
    source 'joindomain.erb'
    mode '0700'
    variables ({
      :domainadmin => opts['domainadmin'],
      :domainadminpassword => opts['domainadminpassword'],
      :domainpath => opts['domainpath'],
      :kbrealm => opts['kbrealm'],
      :specificserver => opts['specificserver']
    })
  end

  execute 'joindomain script' do
    command '/tmp/joindomain.sh'
    action :run
  end
end
