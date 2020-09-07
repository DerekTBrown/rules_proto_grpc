load("//python:python_grpc_compile.bzl", "python_grpc_compile")

def python_grpc_library(**kwargs):
    # Compile protos
    name_pb = kwargs.get("name") + "_pb"
    python_grpc_compile(
        name = name_pb,
        **{k: v for (k, v) in kwargs.items() if k in ("deps", "verbose")} # Forward args
    )

    # Pick deps based on python version
    if "python_version" not in kwargs or kwargs["python_version"] == "PY3":
        grpc_deps = GRPC_PYTHON3_DEPS
    elif kwargs["python_version"] == "PY2":
        grpc_deps = GRPC_PYTHON2_DEPS
    else:
        fail("The 'python_version' attribute to python_grpc_library must be one of ['PY2', 'PY3']")


    # Create python library
    native.py_library(
        name = kwargs.get("name"),
        srcs = [name_pb],
        deps = [
            "@com_google_protobuf//:protobuf_python",
        ] + kwargs.get("grpc_deps", grpc_deps),
        imports = [name_pb],
        visibility = kwargs.get("visibility"),
    )

GRPC_PYTHON2_DEPS = [
    "@rules_proto_grpc_py2_deps_pypi__grpcio_1_25_0//:pkg",
]

GRPC_PYTHON3_DEPS = [
    "@rules_proto_grpc_py3_deps_pypi__grpcio_1_25_0//:pkg",
]
