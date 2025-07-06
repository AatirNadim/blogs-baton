#!/usr/bin/env python3
import os
import shutil
import tarfile
from datetime import datetime, timedelta

# --- Configuration ---
LOG_DIR = './app_logs' # Use a local dir for safe testing
BACKUP_DIR = './backups'
YESTERDAY = datetime.now() - timedelta(days=1)
YESTERDAY_STR = YESTERDAY.strftime('%Y-%m-%d')

def main():
    """Main function to orchestrate the backup process."""
    print("--- Starting daily log backup script ---")

    # 1. Setup: Ensure directories exist for the demo
    os.makedirs(LOG_DIR, exist_ok=True)
    os.makedirs(BACKUP_DIR, exist_ok=True)
    # Create some dummy log files for yesterday
    for i in range(3):
        with open(os.path.join(LOG_DIR, f'app.{YESTERDAY_STR}.{i}.log'), 'w') as f:
            f.write("This is a dummy log file.")
    # Create a log file for today that should NOT be backed up
    with open(os.path.join(LOG_DIR, f'app.{datetime.now().strftime("%Y-%m-%d")}.0.log'), 'w') as f:
        f.write("This is today's log.")


    # 2. Find yesterday's log files
    try:
        all_files = os.listdir(LOG_DIR)
        files_to_archive = [f for f in all_files if YESTERDAY_STR in f and f.endswith('.log')]

        if not files_to_archive:
            print("No log files from yesterday found. Exiting.")
            return

        print(f"Found {len(files_to_archive)} log files to archive: {files_to_archive}")

        # 3. Create the compressed archive
        archive_name = f'logs_{YESTERDAY_STR}.tar.gz'
        archive_path = os.path.join(BACKUP_DIR, archive_name)

        # The 'with' statement ensures the file is properly closed even if errors occur
        with tarfile.open(archive_path, "w:gz") as tar:
            for filename in files_to_archive:
                full_path = os.path.join(LOG_DIR, filename)
                tar.add(full_path, arcname=filename) # arcname stores file without the source directory path

        print(f"Successfully created archive: {archive_path}")

        # 4. Delete the original files
        print("Deleting original log files...")
        for filename in files_to_archive:
            os.remove(os.path.join(LOG_DIR, filename))

        print("--- Backup script finished successfully ---")

    except FileNotFoundError:
        print(f"Error: Log directory not found at '{LOG_DIR}'")
    except Exception as e:
        # Generic catch-all for any other unexpected errors
        print(f"An unexpected error occurred: {e}")

if __name__ == '__main__':
    main()