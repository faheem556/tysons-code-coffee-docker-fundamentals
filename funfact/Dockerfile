FROM mcr.microsoft.com/dotnet/core/sdk:2.2.105-bionic as build
WORKDIR /dotnet

# copy csproj files and resotre
COPY funfact.csproj /dotnet
RUN dotnet restore

# copy all code
COPY . /dotnet
RUN dotnet build

# publish project
RUN dotnet publish --no-restore -c Release -o /dotnet/app


FROM mcr.microsoft.com/dotnet/core/aspnet:2.2.2-bionic

# set user, healthcheck, workdir, and command
WORKDIR /app
HEALTHCHECK --interval=10s --timeout=3s --start-period=2m \
  CMD curl --fail http://localhost:5000 || exit 1  

     
CMD ["dotnet", "funfact.dll"]

# copy application files
COPY --from=build /dotnet/app /app