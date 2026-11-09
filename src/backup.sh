#!/usr/bin/env bash

bkp_dir="$HOME/bkp"
bkp_file_name="$HOME/bkp-$(date +"%Y-%m-%d%H%M%S").tar.gz"
dir=("${@:1}")

# Import log and die function
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

validateParameters() {
	[[ ${#dir[@]} == 0 ]] \
		&& die "You need to inform some file and/or directory"
}

createBkpDir() {
	[[ ! -d "$bkp_dir" ]] && mkdir bkp_dir
}

validateFile() {
	[[ -e "$1" ]] || die "The file/directory '$f' does not exist"
}

uploadFileToBkpDir() {
	cp -ru "$1" "$bkp_dir" || die "Failed to backup '$1'"
	log SUCCESS "File/Directory '$1' uploaded to backup folder"
}

compactBkpDir() {
	log INFO "Compacting backup folder..."
	temp_bkp_file_name="$bkp_file_name"+".tmp"

	tar -czf "$temp_bkp_file_name" "$bkp_dir" \
		&& mv "$temp_bkp_file_name" "$bkp_file_name" \
		|| die "Compacting process failed"
}

main() {
	log INFO "Backup process initializing..."

	validateParameters
	createBkpDir
	
	for f in "${dir[@]}"; do
		validateFile "$f" 
		uploadFileToBkpDir "$f"
	done
	
	log INFO "All files and/or directories were uploaded to backup folder"

	compactBkpDir
	
	log Success "Backup completed and available on $bkp_file_name"
}

main
