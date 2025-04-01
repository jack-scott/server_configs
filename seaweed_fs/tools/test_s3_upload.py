import boto3
import os

def upload_folder_to_s3(client, folder_path, bucket_name):
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            file_path = os.path.join(root, file)
            s3_key = os.path.relpath(file_path, folder_path)
            try:
                client.upload_file(file_path, bucket_name, s3_key)
                print(f'Successfully uploaded {file_path} to s3://{bucket_name}/{s3_key}')
            except Exception as e:
                print(f'Failed to upload {file_path}: {e}')

    
def upload_file_to_s3(client, file_path, bucket_name):
    s3_key = os.path.basename(file_path)
    try:
        client.upload_file(file_path, bucket_name, s3_key)
        print(f'Successfully uploaded {file_path} to s3://{bucket_name}/{s3_key}')
    except Exception as e:
        print(f'Failed to upload {file_path}: {e}')
  

def list_buckets(client):
    response = client.list_buckets()
    return [bucket['Name'] for bucket in response['Buckets']]

def list_files_in_bucket(client, bucket):
    try:
        response = client.list_objects_v2(Bucket=bucket)
        if 'Contents' in response:
            files = [obj['Key'] for obj in response['Contents']]
            return files
        return []
    except Exception as e:
        print(f'Failed to list files in bucket {bucket}: {e}')
        return []

def fetch_file_from_s3(client, bucket, key):
    try:
        response = client.get_object(Bucket=bucket, Key=key)
        return response['Body'].read()
    except Exception as e:
        print(f'Failed to fetch file from s3://{bucket}/{key}: {e}')
        return None


if __name__ == '__main__':
    # Example usage
    test_folder = '/tmp/test_s3_upload'
    test_file = f'{test_folder}/test_file.txt'

    # Create a test folder and file
    os.makedirs(test_folder, exist_ok=True)
    with open(test_file, 'w') as f:
        f.write('This is a test file.')
    # Define paths and bucket name

    bucket_name = 'test_bucket'  # Replace with your bucket name

    # Initialize S3 client
    client = boto3.client('s3', endpoint_url='http://localhost:8333', aws_access_key_id='me', aws_secret_access_key='any')
    
    # Upload folder to S3
    upload_folder_to_s3(client, test_folder, bucket_name)
    # Upload file to S3
    upload_file_to_s3(client, test_file, bucket_name)
    # List all buckets
    buckets = list_buckets(client)

    print("####### Contents of s3 #######")
    print("All buckets:")
    for bucket in buckets:
        print(f"     {bucket}")

    print("####### Files in bucket #######")
    for bucket in buckets:
        files = list_files_in_bucket(client, bucket)
        print(f"Files in bucket {bucket}:")
        for file in files:
            print(f"     {file}")

    # Fetch the test file from s3
    test_file_content = fetch_file_from_s3(client, bucket_name, 'test_file.txt')
    print(f"Test file content: {test_file_content}")


    