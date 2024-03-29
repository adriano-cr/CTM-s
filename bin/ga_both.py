import time

import numpy

from model import main_ga
import pygad
import csv

if __name__ == '__main__':
    gen = 0

    def new_gen(ga):
        global gen

        gen = ga.generations_completed
        print("\n")
        print("************************************")
        print("gen: " + str(gen))
        print("************************************")
        print("\n")



    t = time.time()

    path = ("H:/Il mio Drive/Tesi magistrale/CTMs-identification/fnc/extracted_data/CTM_param_out_nice.xls")
    # path = ("C:/A_Tesi/CTMs-identification/fnc/extracted_data/CTM_param_out_nice.xls")
    # path = "C:/Users/adria/Documents/Uni/LM II anno/Tesi/CTMs-identification/fnc/extracted_data/CTM_param_out_nice.xls"

    path_file_output = "../data/ga_both_result.csv"

    duration = 8640  # k=24h=8640 , k=1h=360, k=3h=1080
    #onramps = [[1000, 500, 4, 0.05]]
    #offramps = [[8, 0.05]]
    rsmax = 1500
    p = 0.05
    onramps = []
    offramps = []

    station = [1, 1, 1, 1]

    gene_type = [int, int, int, float]
    gene_space = [{'low': 1, 'high': 12}, {'low': 2, 'high': 13},
                  {'low': 1, 'high': 720}, {'low': 0, 'high': 0.2}]

    parallel_processing = 12

    function_inputs = [station[0], station[1], station[2], station[3]]

    num_generations = 25
    num_parents_mating = 4

    sol_per_pop = 16
    num_genes = len(function_inputs)

    init_range_low = 0
    init_range_high = 720

    parent_selection_type = "sss"
    keep_parents = -1

    crossover_type = "two_points"
    crossover_probability = 0.5

    mutation_type = "random"
    mutation_num_genes = 1
    mutation_by_replacement = True
#    initial_population = [[1, 2, 300, 0.1], [3, 6, 120, 0.05], [7, 9, 720, 0.2], [11, 12, 50, 0.02]]
    initial_population = None

    stop_criteria = "saturate_7"
    on_generation = new_gen


    with open(path_file_output, 'w', encoding='UTF8', newline='') as f:
        writer = csv.writer(f, delimiter=';')
        header = ["generation", "i", "j", "delta","beta", "integral", "pi", "fitness"]
        writer.writerow(header)
        def fitness_func(solution, solution_idx):
            output = [0, 0]
            if solution[0] < solution[1]:
                output = main_ga.ga(path, duration, rsmax, p, solution, onramps, offramps)
                fit_int = 1000000 / output[0]
                fit_pi = 20000 * output[1]
                fitness = fit_int + fit_pi
                print("Solution: [i: " + str(solution[0]) + ", j: " + str(solution[1]) +
                      ", delta: " + str(solution[2]) + ", beta: " + str(solution[3]) + "]\n" +
                      "Fitness Integral: " + str(fit_int)+
                      "\nFitness PI: " + str(fit_pi)+
                      "\nFitness: " + str(fitness))
                writer.writerow([gen, solution[0], solution[1], solution[2], solution[3], output[0], output[1], fitness])
            else:
                fitness = 0
                print("Invalid solution: i>j")
            return fitness



        fitness_function = fitness_func

        ga_instance = pygad.GA(num_generations=num_generations,
                               num_parents_mating=num_parents_mating,
                               fitness_func=fitness_function,
                               sol_per_pop=sol_per_pop,
                               num_genes=num_genes,
                               gene_type=gene_type,
                               gene_space=gene_space,
                               on_generation=on_generation,
                               stop_criteria=stop_criteria,
                               init_range_low=init_range_low,
                               init_range_high=init_range_high,
                               mutation_by_replacement=mutation_by_replacement,
                               initial_population=initial_population,
                               crossover_probability=crossover_probability,
                               parent_selection_type=parent_selection_type,
                               keep_parents=keep_parents,
                               crossover_type=crossover_type,
                               mutation_type=mutation_type,
                               mutation_num_genes=mutation_num_genes,
                             #  mutation_percent_genes=mutation_percent_genes,
                               parallel_processing=parallel_processing)

        ga_instance.run()

        solution, solution_fitness, solution_idx = ga_instance.best_solution()
        print("Parameters of the best solution : {solution}".format(solution=solution))
        print("Fitness value of the best solution = {solution_fitness}".format(solution_fitness=solution_fitness))

        prediction = numpy.sum(numpy.array(function_inputs) * solution)
        print("Predicted output based on the best solution : {prediction}".format(prediction=prediction))

        elapsed = time.time() - t
        print("Elapsed time: " + str(elapsed))
        ga_instance.plot_fitness(title="Fitness across generations")
