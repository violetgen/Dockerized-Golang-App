FROM golang:latest as builder 

# Add maintainer info
LABEL maintainer "steven <steven@gmail.com>"

#Set the Current Working directory inside the container 
WORKDIR /app

# Copy go mod and sum files 
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed 
RUN go mod download

# Copy the source from the  current directory to the woring directory inside  the container 
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Start a new stage from scratch
FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# COop the Pre-built binary file from the previoud stage
COPY --from=builder /app/main .

# Expose port 8080 to the outside world
EXPOSE 8080

#Command to run the executable
CMD ["./main"] 
