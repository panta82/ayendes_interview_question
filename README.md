# Ayende's interview question

Coded in Swift, as an excercise.

The task is described [here](https://ayende.com/blog/176034/making-code-faster-the-interview-question).

> We have the following file (the full data set is 276 MB), that contains the entry / exit log to a parking lot.
> 
> ![Image from ayende.com blog](images/original_image_thumb.png)
> 
> The first value is the entry time, the second is the exit time and the third is the car id.
> 
> Details about this file: This is UTF8 text file with space separated values using Windows line ending.
> 
> What we need to do is to find out how much time a car spent in the lot based on this file.

The data and the original solution are included inside `/task` directory. You need to unzip it before you start. There is also `short.txt`, which is a smaller dataset, suitable for testing.

### Usage

```bash
cd cloned-project-directory
unzip task/data.zip -d task/
swift build
./.build/debug/ayende ./task/data.txt 
# or
./.build/debug/ayende < ./task/data.txt 
```

### Note

There seems to be a bug with `StreamReader` which corrupts console output in some cases. You're better off using the stdin method.