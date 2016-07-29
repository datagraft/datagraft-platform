#!/bin/bash

# Create a user with following credentials: administrator, administrator@datagraft.net, password

# Check that we have all the arguments that we need
if [ "$#" != 3 ];
then
    echo "Usage: $0 <uid> <secret> <redirect_uri>"
    exit
fi

uid=$1
secret=$2
redirect_uri=$3

docker exec -t datagraft-db bash -c 'until head -c 0 </dev/tcp/127.0.0.1/5432; do sleep 1; done'

docker exec datagraft-portal rake db:migrate

docker exec -i datagraft-db psql --user=postgres --dbname=datagraft-prod << EOF

INSERT INTO users VALUES (1, 'administrator@datagraft.net', '\$2a\$10\$ArX10aADrz93gpptvrDkLuITB8O7s75IYnOjHBtCS/Tcp4OUJBwC2', null, null, null, 1, '2016-05-09 12:19:41.745909', '2016-05-09 12:19:41.745909', '10.0.2.2', '10.0.2.2', '2016-05-09 12:19:41.740838', '2016-05-09 12:19:41.747083', null, null, null, null, null, null, null, 'administrator', 0, true);

INSERT INTO oauth_applications (id, name, uid, secret, redirect_uri, scopes, created_at, updated_at) VALUES (1, 'Grafterizer', '$uid', '$secret', '$redirect_uri', 'public', '2016-05-04 08:44:01.702687', '2016-05-04 08:44:01.702687');
EOF
