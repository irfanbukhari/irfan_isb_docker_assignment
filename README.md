# Using the docker file create an image, using the command
# docker build -t test1 .

# using the built docker image, create a docker container
# docker run -p 444:8888 -v <path to ipython notebook file>

# the link will be provided for the jupyter notebook.
# upload the ipython notebook and the dataset file.

# once done we can run the file.
# to save the docker 
# use docker commit <id of the docker container> <new name for the image to create>
# now 
# docker tag <newly created image> dockerhub_name/<any_repo>:latest
# finally
# docker push dockerhubname/<any_repo>

# Since the last three steps were taking more than 10-12 hours due to internet speed. It could not be pushed to the docker hub.