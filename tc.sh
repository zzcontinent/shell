mkdir -p /sys/kernel/debug
mount -t debugfs debugfs /sys/kernel/debug/
cd /sys/kernel/debug/tracing

echo 0 > tracing_on
echo function_graph > current_tracer

echo verbose > trace_options
echo latency-format > trace_options
echo irq-info > trace_options
echo funcgraph-proc > trace_options
echo funcgraph-duration > trace_options
echo funcgraph-irqs > trace_options
echo funcgraph-tail > trace_options
echo graph-time > trace_options
echo sleep-time > trace_options


echo 1 > tracing_on; sigwaittest -t -l10; echo 0 > tracing_on

cat trace > ~/trace.log
