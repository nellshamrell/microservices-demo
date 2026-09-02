using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Hosting;
using cartservice.cartstore;
using cartservice.services;
using Microsoft.Extensions.Caching.StackExchangeRedis;
using StackExchange.Redis;

namespace cartservice
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }
        
        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            string redisAddress = Configuration["REDIS_ADDR"];
            string spannerProjectId = Configuration["SPANNER_PROJECT"];
            string spannerConnectionString = Configuration["SPANNER_CONNECTION_STRING"];
            string alloyDBConnectionString = Configuration["ALLOYDB_PRIMARY_IP"];

            if (!string.IsNullOrEmpty(redisAddress))
            {
                services.AddStackExchangeRedisCache(options =>
                {
                    ConfigureRedis(options, redisAddress);
                });
                services.AddSingleton<ICartStore, RedisCartStore>();
            }
            else if (!string.IsNullOrEmpty(spannerProjectId) || !string.IsNullOrEmpty(spannerConnectionString))
            {
                services.AddSingleton<ICartStore, SpannerCartStore>();
            }
            else if (!string.IsNullOrEmpty(alloyDBConnectionString))
            {
                Console.WriteLine("Creating AlloyDB cart store");
                services.AddSingleton<ICartStore, AlloyDBCartStore>();
            }
            else
            {
                Console.WriteLine("Redis cache host(hostname+port) was not specified. Starting a cart service using in memory store");
                services.AddDistributedMemoryCache();
                services.AddSingleton<ICartStore, RedisCartStore>();
            }


            services.AddGrpc();
        }

        private static void ConfigureRedis(RedisCacheOptions options, string address)
        {
            if (!Uri.TryCreate(address, UriKind.Absolute, out var uri) ||
                (uri.Scheme != "redis" && uri.Scheme != "rediss"))
            {
                options.Configuration = address;
                return;
            }

            var redisOptions = new ConfigurationOptions
            {
                AbortOnConnectFail = false,
                Ssl = uri.Scheme == "rediss"
            };
            redisOptions.EndPoints.Add(uri.Host, uri.Port);

            var separator = uri.UserInfo.IndexOf(':');
            if (separator >= 0)
            {
                var user = Uri.UnescapeDataString(uri.UserInfo[..separator]);
                if (!string.IsNullOrEmpty(user))
                {
                    redisOptions.User = user;
                }

                redisOptions.Password = Uri.UnescapeDataString(uri.UserInfo[(separator + 1)..]);
            }
            else if (!string.IsNullOrEmpty(uri.UserInfo))
            {
                redisOptions.Password = Uri.UnescapeDataString(uri.UserInfo);
            }

            options.ConfigurationOptions = redisOptions;
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapGrpcService<CartService>();
                endpoints.MapGrpcService<cartservice.services.HealthCheckService>();

                endpoints.MapGet("/", async context =>
                {
                    await context.Response.WriteAsync("Communication with gRPC endpoints must be made through a gRPC client. To learn how to create a client, visit: https://go.microsoft.com/fwlink/?linkid=2086909");
                });
            });
        }
    }
}
