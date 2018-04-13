#!/bin/sh^M
mongo admin << EOF
use admin;
db.createUser({
    user: 'useradmin',
    pwd: '${PASS}',
    roles:[{
        role:'userAdminAnyDatabase',
        db:'admin'
    }]
});
exit
EOF

mongo admin -u useradmin -p ${PASS} << EOF
use DbName;
db.createUser({
    user: ${USER},
    pwd: ${PASS},
    roles:[{
        role:'readWrite',
        db:${DATABASE}
    }]
});
exit
EOF

mongo -u yourUser -p yourPass DbName << EOF
 ...Your_MongoDB_Commands_Here
EOF



