# Dockerfile (multi-stage)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# copy csproj and restore first to leverage cache
COPY *.csproj ./
RUN dotnet restore

# copy the rest and publish
COPY . .
RUN dotnet publish -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app . 
# Listen on 8080 inside container
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# <replace YourAppName.dll with your actual output dll>
ENTRYPOINT ["dotnet", "WebApplication1.dll"]
