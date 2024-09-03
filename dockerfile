# Use the official .NET SDK as a build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY dotnet-api.csproj ./
RUN dotnet restore dotnet-api.csproj

# Copy everything else and build
COPY . ./
RUN dotnet publish dotnet-api.csproj -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose the port on which the app will run
EXPOSE 8080

# Run the application
ENTRYPOINT ["dotnet", "dotnet-api.dll"]