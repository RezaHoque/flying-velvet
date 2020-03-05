FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 443
ENV ASPNETCORE_URLS=http://*:8080


FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["flying-vetvet.csproj", "./"]
RUN dotnet restore "./flying-vetvet.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "flying-vetvet.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "flying-vetvet.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "flying-vetvet.dll"]
