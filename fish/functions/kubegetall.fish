function kubectlgetall
    set namespace $argv[1]

    for i in (kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq)
        echo "Resource: $i"
        kubectl -n $namespace get --ignore-not-found $i
    end
end
