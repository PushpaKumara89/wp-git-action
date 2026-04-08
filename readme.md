## image remove from minikube
`minikube image ls`
`minikube image rm <image_name>`

## How to send images from Docker to Minikube
`minikube image load <image_name>:<tag>`

## make cofigmap with .env file
`kubectl create configmap spring-env --from-env-file=.env.dev`


## app down without volume
`docker-compose down`

## app down with volume
`docker-compose down -v`

## get database backup from mysql container
### PowerShell
`docker exec testphp-wordpress-db-1 mysqldump -u usr_pk --password=1234pk --no-tablespaces --skip-column-statistics wordpress | Out-File -FilePath db/backup.sql -Encoding utf8`
### WSL
`docker exec testphp-wordpress-db-1 mysqldump -u root --password=1234root --no-tablespaces --skip-column-statistics wordpress > backup.sql`

`mysql -u usr_pk -p1234pk --binary-mode wordpress < backup.sql`


# K8S
`kubectl create configmap mysql-init-script --from-file=backup.sql=db/backup.sql`

`minikube mount E:\vm-share\testPHP-WordPress\db:/mnt/e/db`

`minikube ssh "ls /mnt/e/db"`

## how save docker image as a file out 

========================

## Traffic Check Script
```powershell
define('WP_DEBUG_LOG', !!getenv_docker('WORDPRESS_DEBUG_LOG', ''));
```

### Create RsT-API with debug error WordPress 
#### add to \wp-content\themes\twentytwenty...\functions.php
```powershell
add_action( 'rest_api_init', function () {
    register_rest_route( 'api/v1', '/info', array(
        'methods'  => 'GET', // Could also be 'POST'
        'callback' => 'get_custom_wp_data',
        'permission_callback' => '__return_true', // Caution: This makes it public
    ) );
});

function get_custom_wp_data() {
    // 1. Create a standard PHP associative array
    $data = array(
        'status'      => 'success',
        'php_version' => phpversion(),
        'time'        => current_time( 'mysql' ),
        'hostname'    => gethostname(),
    );

    // 2. Log it for debugging (using print_r on the array, not the JSON string)
    error_log("Host Data: " . print_r(json_encode($data), true));

    // 3. Just return the array. WordPress handles the json_encode() and headers for you!
    return rest_ensure_response( $data );
}
```


## Use this PowerShell loop to monitor the Load Balancer. Using `curl.exe` instead of `Invoke-RestMethod` helps bypass internal connection pooling to see the traffic rotate between Pods.

```http://localhost:3030/index.php/wp-json/api/v1/info```
```powershell
while ($true) {
    # Call the Windows version of curl to ensure fresh connections
    curl.exe -s http://localhost:3030/index.php?rest_route=/api/v1/info
    
    # Add a newline for readability in the console
    Write-Host "" 
    
    # Wait 1 second before the next request
    Start-Sleep -Seconds 1
}
```

sudo rm -rf /mnt/disks/st-wp/* 