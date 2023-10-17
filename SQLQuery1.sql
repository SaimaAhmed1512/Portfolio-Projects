Select *
From [Portfolio Project Covid]..CovidDeaths
Where continent is not null
order by 3,4

Select *
From [Portfolio Project Covid]..CovidVaccinations
order by 3,4

Select continent, Location, date, total_cases, new_cases, total_deaths, population 
From [Portfolio Project Covid]..CovidDeaths
Where continent is not null
order by 1,2

Select Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project Covid]..CovidDeaths
Where Location like '%United Kingdom%'
order by 1,2

Select Location, date, population,  total_cases, (total_cases/population)*100 as Percent_Population_Infected
From [Portfolio Project Covid]..CovidDeaths 
Where Location like '%United Kingdom%'
order by 1,2 


Select continent, Location, Population, MAX(total_cases) as Highest_infection_count, MAX((total_cases/population)*100) as Percent_Population_Infected 
From [Portfolio Project Covid]..CovidDeaths
Group by continent, Location, Population
order by Percent_Population_Infected desc

Select continent, Location, MAX(cast(total_deaths as int)) as total_death_count
From [Portfolio Project Covid]..CovidDeaths
where continent is not null
Group by Location, continent
Order by total_death_count desc

Select location, MAX(cast(total_deaths as int)) as total_death_count
From [Portfolio Project Covid]..CovidDeaths
Where continent is null
Group by location
Order by total_death_count desc

Select continent, MAX(cast(total_deaths as int)) as total_death_count
From [Portfolio Project Covid]..CovidDeaths
Where continent is not null
Group by continent
Order by total_death_count desc


Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From [Portfolio Project Covid]..CovidDeaths
Where continent is not null
Group by date
order by 1,2

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From [Portfolio Project Covid]..CovidDeaths
Where continent is not null
order by 1,2

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date 
where dea.continent is not null 
order by 2, 3 

With PopvsVac (Continent, Location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date 
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
new_vaccinations numeric, 
RollingPeopleVaccinated numeric, 
)


Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date 
where dea.continent is not null 
order by 2, 3 

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date 
where dea.continent is not null 

create view DeathPercentageDate as 
Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From [Portfolio Project Covid]..CovidDeaths
Where continent is not null
Group by date

Create view ContinentTotalDeathCount as 
Select continent, MAX(cast(total_deaths as int)) as total_death_count
From [Portfolio Project Covid]..CovidDeaths
Where continent is not null
Group by continent

Create view LocationTotalDeathCount as 
Select location, MAX(cast(total_deaths as int)) as total_death_count
From [Portfolio Project Covid]..CovidDeaths
Where continent is null
Group by location

Create view LocationPercentPopulationInfected as 
Select continent, Location, Population, MAX(total_cases) as Highest_infection_count, MAX((total_cases/population)*100) as Percent_Population_Infected 
From [Portfolio Project Covid]..CovidDeaths
Group by continent, Location, Population

Create view UKspecificPercentPopulationInfected as 
Select Location, date, population,  total_cases, (total_cases/population)*100 as Percent_Population_Infected
From [Portfolio Project Covid]..CovidDeaths 
Where Location like '%United Kingdom%'
