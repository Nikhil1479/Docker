# Dockerizing an Express App 
We are going to dockerize an `express` application.
## Express App`fas:Js`
This code sets up a basic Express server that listens for incoming GET requests on the root path ("/") and responds with a simple "Hi There" message in HTML. The server will listen on either the port specified in the `process.env.PORT` environment variable or port `3000` if the environment variable is not set.

```javascript {.line-numbers}
const express = require("express")
const app = express();
app.get("/", (req, res) => {
    res.send("<h2> Hi There </h2>");
});
const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`listening on port ${port}`))
```

## Docker Image `fas:Docker`
In Docker, everything is based on Images. An image is a combination of a file system and parameters. Let’s take an example of the following command in Docker.
### Creating a Docker image
- Docker images are built using `Dockerfile`   
- Docker images are built using layers 
- Check the below example:
```Dockerfile {.line-numbers}
FROM node:15
WORKDIR /app
COPY package.json .
RUN npm install
COPY . ./
EXPOSE 3000
CMD ["node", "index.js"]
```

- The above `Dockerfile` `fas:Docker` will create an image from a base image `node:15` `[IMAGE_NAME:TAG]`. Here we are using a base image of `node` version `15`. 
- Docker Images are build layer wise. 
- Here `FROM node:15` is base layer, and above that layer all other layers are cached.
#### Let's look deeper into the code`fas:Code`
- `WORKDIR /app` will set the working directory inside the container.
- `COPY package.json .` will copy the `package.json` file which is present locally inside the container to install dependencies. 
- `RUN` it is an image build step the state of the container after a `RUN` command will be committed to the container image. A Dockerfile can have many `RUN` steps that layer on top of one another to build the image.
- `RUN npm install` it will install all the dependencies which is listed in `package.json`.
- `EXPOSE 3000` this will expose the port 3000.
- `CMD` is the command the container executes by default **when you launch** the built image. A Dockerfile will only use the final `CMD` defined. The `CMD` **can be overridden** when starting a container with `docker run $image`
- `CMD ["node", "index.js"]` this will execute the command inside the container in order to run the `express` app.
So, basically the above code are the instructions or steps which should be executed sequentially while building an container from an image.

#### Docker Build `fas:Docker`
To build an image from this `Dockerfile` you need to execute this command `docker build` command.
`docker build` command builds Docker images `fas:CompactDisc` from a `Dockerfile`.

General Docker Build Image Command
```sh
$ docker build [OPTIONS] PATH | URL | -
```


Building our Docker Image:
```sh
$ docker build -t node-app-image
```
## Docker Container `fas:Docker`
- Containers  are instance of docker images that can be run using `docker run` command .
- Basic purpose of Docker is to run containers.
### Running a Container
- Running containers is managed by `docker run` command. To run a container we use following command.
- We will be running our `express-app` using docker image which we created earlier `node-app-image`.
#### Docker run `fas:ProjectDiagram`
The `docker run` command runs a command in a new container, pulling the image if needed and starting the container.
You can restart a stopped container with all its previous changes intact using `docker start`. Use `docker ps -a` to view a list of all containers, including those that are stopped.

##### To run our docker container `node-app-image` we will execute:
```sh
$ docker run -p 4000:3000 -d --name node-app node-app-image
```
###### Command Breakdown `fas:Terminal`
- `docker run` Runs the command in container, pulling image if needed.
- `docker run -p 4000:3000` So, as docker container are completely isolated from other systems, so we can't access our `express-app` from outside container, instead we can specify that the traffic coming to the port `4000` in our local machine should be redirected to port `3000` of the docker container.
- `docker run -p 4000:3000 -d` this flag `-d` detaches our container from our terminal and runs the container in background, though printing the container id to terminal.
- `docker run -p 4000:3000 -d --name node-app node-app-image` specifying the container name `node-app` and giving the image `node-app-image` to run a container.
### Running an interactive shell inside container
- If you need to start an interactive shell inside a Docker Container, perhaps to explore the file system or debug running processes, use `docker exec` command with `-i` and `-t` flags.
- The `-i` flag keeps input open to the container, and the `-t` flag creates a pseudo-terminal that the shell can attach to. These flags can be combined like this:
```sh
$ docker exec -it node-app
```
![[Pasted image 20230919163356.png]]
- In the above screenshot we can see all the files inside our container.
- We can see that there are some unnecessary files like `Dockerfile`, `node_module` which aren't necessary.
- These files are creating inside docker container because of `COPY . ./` command in our `Dockerfile`.
- So, to don't include these files or folders inside our container we will use `.dockerignore`.
### Docker Ignore
- Create a file inside your project folder `.dockerignore`.
- Include all the file and folder names in the file which you don't want to copy inside the container.
```dockerignore
node_modules
.vscode
Dockerfile
.gitignore
files
.obsidian
```
- Re build the docker image
```sh
$ docker built -t node-app-image
```












