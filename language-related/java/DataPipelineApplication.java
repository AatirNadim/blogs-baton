
import com.google.common.util.concurrent.RateLimiter;
import java.time.Instant;
import java.util.concurrent.*;


/*
  * A simple data pipeline application that simulates log processing.
  * It uses a BlockingQueue to hold raw logs, processes them in parallel,
  * and forwards the processed logs to a downstream service.
  * The application limits the rate of log production to avoid overwhelming the system.
*/


record LogEvent(String sourceIp, Instant eventTime, String message, Instant processingTime) {

}

class DataForwarder {

    // Simulates an asynchronous call to a database or another web service
    public void sendToDownstreamService(LogEvent event) {
        System.out.printf("[FORWARDER] Sending event from IP %s to analytics DB...%n", event.sourceIp());
        // In a real app, this would use an HTTP client or DB connection pool.
        // We'll just sleep to simulate network latency.
        try {
            Thread.sleep(50); // Simulate 50ms network call
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}

class LogProcessor {

    private final BlockingQueue<String> rawLogQueue;
    private final ExecutorService processingPool;
    private final DataForwarder dataForwarder;

    public LogProcessor(BlockingQueue<String> rawLogQueue) {
        this.rawLogQueue = rawLogQueue;
        // Create a thread pool with 4 worker threads to process logs concurrently
        this.processingPool = Executors.newFixedThreadPool(4);
        this.dataForwarder = new DataForwarder();
    }

    public void start() {
        System.out.println("LogProcessor started with 4 worker threads.");
        // One thread to pull from the queue and submit tasks to the pool
        Runnable dispatcher = () -> {
            while (!Thread.currentThread().isInterrupted()) {
                try {
                    String rawLog = rawLogQueue.take(); // Blocks until a log is available
                    // Submit the processing of this log to a worker thread
                    processingPool.submit(() -> processAndForward(rawLog));
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        };
        new Thread(dispatcher).start();
    }

    private void processAndForward(String rawLog) {
        System.out.println("[WORKER " + Thread.currentThread().getId() + "] Processing log: " + rawLog);
        // Simulate parsing and transformation
        String[] parts = rawLog.split(",");
        if (parts.length == 3) {
            LogEvent event = new LogEvent(
                    parts[0], // sourceIp
                    Instant.parse(parts[1]), // eventTime
                    parts[2], // message
                    Instant.now() // processingTime (enrichment)
            );
            dataForwarder.sendToDownstreamService(event);
        } else {
            System.err.println("Malformed log entry: " + rawLog);
        }
    }

    public void stop() {
        processingPool.shutdownNow();
    }

}

public class DataPipelineApplication {

    public static void main(String[] args) throws InterruptedException {
        BlockingQueue<String> logQueue = new ArrayBlockingQueue<>(1000);

        // Start the processing engine
        LogProcessor processor = new LogProcessor(logQueue);
        processor.start();

        // it is always good to limit the rate of log production to avoid overwhelming the system

        // Here we use Guava's RateLimiter to limit log production to 10 logs per second
        // This simulates a controlled rate of incoming logs, which is common in real-world applications
        // to prevent spikes that could overwhelm the processing pipeline.
        // In a production system, you might use a more sophisticated rate limiting strategy
        // based on the actual load and capacity of your processing system.
        final RateLimiter rateLimiter = RateLimiter.create(10.0);

        System.out.println("Starting log producer, limited to 10 logs/sec...");
        for (int i = 0; i < 50; i++) {
            rateLimiter.acquire(); // Blocks until a permit is available
            String log = String.format("192.168.1.%d,%s,User logged in", (i % 20), Instant.now());
            logQueue.put(log); // Puts log in the queue, blocks if full
        }

        System.out.println("Producer finished. Waiting 5s for processing to complete...");
        Thread.sleep(5000);
        processor.stop();
        System.out.println("Application shutdown.");

    }
}
