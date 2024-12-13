#!/bin/bash

# sysopctl v0.1.0 - System Operations Control

# Version and help information
VERSION="v0.1.0"

# Function to display help information
show_help() {
    cat << EOF
Usage: sysopctl [OPTION] [SUBCOMMAND] [ARGS]

Options:
  --help        Show this help message.
  --version     Show version information.

Subcommands:
  service       Manage system services (list, start, stop).
  system        View system load.
  disk          Check disk usage.
  process       Monitor system processes.
  logs          Analyze system logs.
  backup        Backup system files.

Examples:
  sysopctl --help
  sysopctl service list
  sysopctl service start apache2
  sysopctl disk usage
EOF
}

# Function to display version information
show_version() {
    echo "sysopctl $VERSION"
}

# Function to list running services
list_services() {
    systemctl list-units --type=service --state=running
}

# Function to show system load
show_system_load() {
    uptime
}

# Function to start a service
start_service() {
    local service_name="$1"
    sudo systemctl start "$service_name" && echo "Started $service_name service."
}

# Function to stop a service
stop_service() {
    local service_name="$1"
    sudo systemctl stop "$service_name" && echo "Stopped $service_name service."
}

# Function to check disk usage
check_disk_usage() {
    df -h
}

# Function to monitor system processes
monitor_processes() {
    top
}

# Function to analyze system logs
analyze_logs() {
    journalctl -p err --since "1 day ago" --no-pager
}

# Function to backup system files
backup_files() {
    local source_path="$1"
    local backup_path="/backup/$(basename "$source_path")"
    rsync -av --progress "$source_path" "$backup_path" && echo "Backup completed."
}

# Main script logic to parse and execute commands
case "$1" in
    --help)
        show_help
        ;;
    --version)
        show_version
        ;;
    service)
        case "$2" in
            list)
                list_services
                ;;
            start)
                start_service "$3"
                ;;
            stop)
                stop_service "$3"
                ;;
            *)
                echo "Invalid service command. Use --help for usage."
                ;;
        esac
        ;;
    system)
        case "$2" in
            load)
                show_system_load
                ;;
            *)
                echo "Invalid system command. Use --help for usage."
                ;;
        esac
        ;;
    disk)
        case "$2" in
            usage)
                check_disk_usage
                ;;
            *)
                echo "Invalid disk command. Use --help for usage."
                ;;
        esac
        ;;
    process)
        case "$2" in
            monitor)
                monitor_processes
                ;;
            *)
                echo "Invalid process command. Use --help for usage."
                ;;
        esac
        ;;
    logs)
        case "$2" in
            analyze)
                analyze_logs
                ;;
            *)
                echo "Invalid logs command. Use --help for usage."
                ;;
        esac
        ;;
    backup)
        if [ -z "$2" ]; then
            echo "Please specify a path to backup."
        else
            backup_files "$2"
        fi
        ;;
    *)
        echo "Invalid command. Use --help for usage."
        ;;
esac
