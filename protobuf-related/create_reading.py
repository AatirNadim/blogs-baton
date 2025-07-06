import sensor_pb2
import time


reading = sensor_pb2.SensorReading()

# reading = sensor_pb2.()


reading.device_id = "temp_probe-Z24"
reading.temperature_c = 22.5
reading.timestamp_ms = int(time.time() * 1000)  # Current time in milliseconds
reading.status = reading.Status.OK  # Assuming the status is OK
# Print the reading
print(f"Device ID: {reading.device_id}")
print(f"Temperature (C): {reading.temperature_c}")
print(f"Timestamp (ms): {reading.timestamp_ms}")
print(f"Status: {reading.status}")
# Serialize the reading to a binary format
serialized_reading = reading.SerializeToString()
# Print the serialized reading
# # 3. See the result!
# print(f"Python Object: {reading.device_id}, {reading.temperature_c}°C")
# print("-" * 20)
# print(f"Serialized Data ({len(serialized_reading)} bytes): {serialized_reading}")
# Deserialize the reading from the binary format

deserialized_reading = sensor_pb2.SensorReading()
deserialized_reading.ParseFromString(serialized_reading)
# Print the deserialized reading
print("Deserialized Reading:")
print(f"Device ID: {deserialized_reading.device_id}")
print(f"Temperature (C): {deserialized_reading.temperature_c}")
print(f"Timestamp (ms): {deserialized_reading.timestamp_ms}")
