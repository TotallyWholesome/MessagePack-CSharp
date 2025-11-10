// Copyright (c) All contributors. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System.IO;

#pragma warning disable SYSLIB0011 // BinaryFormatter is obsolete - but needed for benchmark comparisons
using System.Runtime.Serialization.Formatters.Binary;
#pragma warning restore SYSLIB0011

namespace Benchmark.Serializers
{
    public class BinaryFormatterSerializer : SerializerBase
    {
#pragma warning disable SYSLIB0011 // BinaryFormatter is obsolete - but needed for benchmark comparisons
        public override T Deserialize<T>(object input)
        {
            using (var ms = new MemoryStream((byte[])input))
            {
                return (T)new BinaryFormatter().Deserialize(ms);
            }
        }

        public override object Serialize<T>(T input)
        {
            using (var ms = new MemoryStream())
            {
                new BinaryFormatter().Serialize(ms, input);
                ms.Flush();
                return ms.ToArray();
            }
        }
#pragma warning restore SYSLIB0011

        public override string ToString()
        {
            return "BinaryFormatter";
        }
    }
}
