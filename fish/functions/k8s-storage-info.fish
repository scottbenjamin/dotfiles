function k8s-storage-info --description "Display detailed Kubernetes storage information for a pod and its related PVC, PV, and StorageClass"
    argparse 'n/namespace=' 'p/pod=' -- $argv
    or return

    # Set defaults if not provided
    set -q _flag_namespace; or set _flag_namespace "default"
    
    if not set -q _flag_pod
        echo "Error: Pod name is required. Usage: k8s-storage-info --pod POD_NAME [--namespace NAMESPACE]"
        return 1
    end

    # Function to print section headers
    function print_header
        set -l title $argv[1]
        echo
        echo (set_color --bold blue)"=== $title ==="(set_color normal)
        echo
    end

    # Get pod details
    print_header "Pod Details"
    kubectl get pod $_flag_pod -n $_flag_namespace -o yaml

    # Get PVC names using jsonpath
    set -l pvc_names (kubectl get pod $_flag_pod -n $_flag_namespace -o jsonpath='{.spec.volumes[?(@.persistentVolumeClaim)].persistentVolumeClaim.claimName}')
    
    if test -n "$pvc_names"
        # Convert space-separated string to array
        set -l pvc_array (string split " " -- $pvc_names)
        
        for pvc in $pvc_array
            print_header "PVC Details: $pvc"
            kubectl get pvc $pvc -n $_flag_namespace -o yaml

            # Get PV name
            set -l pv_name (kubectl get pvc $pvc -n $_flag_namespace -o=jsonpath='{.spec.volumeName}')
            if test -n "$pv_name"
                print_header "PV Details: $pv_name"
                kubectl get pv $pv_name -o yaml

                # Get StorageClass
                set -l sc_name (kubectl get pv $pv_name -o=jsonpath='{.spec.storageClassName}')
                if test -n "$sc_name" -a "$sc_name" != "null"
                    print_header "StorageClass Details: $sc_name"
                    kubectl get sc $sc_name -o yaml
                end
            end
        end
    else
        echo (set_color yellow)"No PVC found for this pod"(set_color normal)
    end
end
