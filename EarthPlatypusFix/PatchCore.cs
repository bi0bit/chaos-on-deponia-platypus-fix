using System;
using System.IO;
using System.IO.Compression;
using System.Security.Cryptography;

public static class EarthPlatypusPatchCore
{
    public static void ReplaceArchive(string source, string destination)
    {
        // Windows PowerShell converts a null string argument to an empty
        // backup path; call this overload from C# to preserve a real null.
        File.Replace(source, destination, null);
    }

    public static string Hash(byte[] bytes)
    {
        using (SHA256 sha = SHA256.Create())
            return BitConverter.ToString(sha.ComputeHash(bytes)).Replace("-", "").ToLowerInvariant();
    }

    // The payload stores XOR differences only. It cannot replace an unknown
    // game archive: both input and output must match the verified build.
    public static void CreatePatchedArchive(string originalPath, string deltaPath,
        string outputPath, string originalHash, string patchedHash)
    {
        byte[] original = File.ReadAllBytes(originalPath);
        if (Hash(original) != originalHash) throw new InvalidDataException("Unsupported game archive.");
        using (FileStream file = File.OpenRead(deltaPath))
        using (GZipStream gzip = new GZipStream(file, CompressionMode.Decompress))
        using (BinaryReader reader = new BinaryReader(gzip))
        {
            byte[] magic = reader.ReadBytes(8);
            if (System.Text.Encoding.ASCII.GetString(magic) != "EPLATYP2")
                throw new InvalidDataException("Invalid patch format.");
            int sourceLength = reader.ReadInt32();
            int targetLength = reader.ReadInt32();
            int segments = reader.ReadInt32();
            if (sourceLength != original.Length || targetLength < sourceLength ||
                targetLength > sourceLength + 65536 || segments < 1 || segments > 32)
                throw new InvalidDataException("Invalid patch sizes.");
            byte[] output = new byte[targetLength];
            Buffer.BlockCopy(original, 0, output, 0, original.Length);
            int previousEnd = 0;
            for (int segment = 0; segment < segments; ++segment)
            {
                int offset = reader.ReadInt32();
                int length = reader.ReadInt32();
                if (offset < previousEnd || length < 1 || offset > targetLength - length)
                    throw new InvalidDataException("Invalid patch segment.");
                byte[] delta = reader.ReadBytes(length);
                if (delta.Length != length) throw new EndOfStreamException("Incomplete patch.");
                for (int i = 0; i < length; ++i) output[offset + i] ^= delta[i];
                previousEnd = offset + length;
            }
            if (reader.Read() != -1) throw new InvalidDataException("Unexpected patch data.");
            if (Hash(output) != patchedHash) throw new InvalidDataException("Patched archive verification failed.");
            using (FileStream destination = new FileStream(outputPath, FileMode.CreateNew, FileAccess.Write))
                destination.Write(output, 0, output.Length);
        }
    }
}
